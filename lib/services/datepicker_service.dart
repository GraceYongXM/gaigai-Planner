import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:supabase/supabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gaigai_planner/models/activity.dart';

class DatePickerService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<bool> everyoneSubmitted(String eventID) async {
    var response = await _client
        .from('events_users')
        .select()
        .eq('event_id', eventID)
        .execute();
    var response2 = await _client
        .from('events_users')
        .select()
        .eq('event_id', eventID)
        .not('location', 'is', null)
        .execute();
    if (response.error == null && response2.error == null) {
      final results = response.data as List<dynamic>;
      final results2 = response2.data as List<dynamic>;
      log('everyoneSubmitted success');
      return results.length == results2.length;
    } else if (response.error == null) {
      log('Error in everyoneSubmitted: ${response2.error!.message}');
      return false;
    } else {
      log('Error in everyoneSubmitted: ${response.error!.message}');
      return false;
    }
  }

  void insertActivities(String eventID) async {
    var response = await _client
        .from('events_activities')
        .select()
        .eq('event_id', eventID)
        .execute();
    // check whether need to insert/update events_activities
    var response2 = await _client
        .from('events_users')
        .select('location')
        .eq('event_id', eventID)
        .execute();
    // get the locations of users in the group
    var response3 = await _client.from('activities').select().execute();
    // get the list of activities
    if (response.error == null && response2.error == null) {
      final results = response.data as List<dynamic>;

      final results2 = response2.data as List<dynamic>;
      List<String> locations =
          results2.map((e) => e['location'] as String).toList();
      locations.removeWhere((element) => element == '');
      List<double> latitudes = [];
      List<double> longitudes = [];
      for (String location in locations) {
        try {
          List<Location> possibleLocations =
              await locationFromAddress(location, localeIdentifier: 'en_SG');
          latitudes.add(possibleLocations[0].latitude);
          longitudes.add(possibleLocations[0].longitude);
        } catch (e) {}
      }

      final results3 = response3.data as List<dynamic>;
      List<Activity> activities = results3
          .map((e) => Activity(
                e['activity_id'],
                e['name'],
                e['location'],
                e['cost'],
                e['distance'],
                e['description'],
                e['latitude'],
                e['longitude'],
              ))
          .toList();

      double totalDistance = 0;

      for (Activity activity in activities) {
        for (int i = 0; i < latitudes.length; i++) {
          totalDistance += Geolocator.distanceBetween(latitudes[i],
              longitudes[i], activity.latitude, activity.longitude);
        }
        totalDistance /= 1000;
        if (results.isEmpty) {
          if (locations.isEmpty) {
            await _client.from('events_activities').insert({
              'activity_id': activity.activityID,
              'event_id': eventID,
              'cost': activity.cost,
              'activity_description': activity.description,
              'activity_name': activity.name,
              'distance': 0,
            }).execute();
          } else {
            await _client.from('events_activities').insert({
              'activity_id': activity.activityID,
              'event_id': eventID,
              'distance': totalDistance / locations.length,
              'cost': activity.cost,
              'activity_description': activity.description,
              'activity_name': activity.name,
            }).execute();
          }
        } else {
          if (locations.isEmpty) {
            await _client
                .from('events_activities')
                .update({'distance': 0}).match({
              'activity_id': activity.activityID,
              'event_id': eventID,
            }).execute();
          } else {
            await _client
                .from('events_activities')
                .update({'distance': totalDistance / locations.length}).match({
              'activity_id': activity.activityID,
              'event_id': eventID,
            }).execute();
          }
        }
      }
    }
  }

  void insertDate(String eventID, String userID, DateTime date) async {
    var response = await _client.from('form_dates').insert({
      'event_id': eventID,
      'user_id': userID,
      'date': '${date.month}/${date.day}/${date.year}',
    }).execute();
    if (response.error == null) {
      log('success in insertDate');
    } else {
      log('Error in insertDate: ${response.error!.message}');
    }
  }

  void insertLocation(String eventID, String userID, String location) async {
    var response = await _client.from('events_users').update({
      'location': location,
    }).match({
      'event_id': eventID,
      'user_id': userID,
    }).execute();
    if (response.error == null) {
      log('success in insertLocation');
    } else {
      log('Error in insertLocation: ${response.error!.message}');
    }
  }

  Future<bool> deleteDates(String userID, String eventID) async {
    var response = await _client.from('form_dates').delete().match({
      'event_id': eventID,
      'user_id': userID,
    }).execute();
    if (response.error == null) {
      log('success in deleteDate');
      return true;
    } else {
      log('Error in deleteDate: ${response.error!.message}');
    }
    return false;
  }
}
