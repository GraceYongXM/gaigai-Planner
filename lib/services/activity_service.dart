import 'dart:developer';

import 'package:gaigai_planner/models/activity.dart';
import 'package:gaigai_planner/models/event_activity.dart';
import 'package:supabase/supabase.dart';

class ActivityService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<List<EventActivity>> getDefaultEventActivity() async {
    final response = await _client.from('events_activities').select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventActivity> eventActivityList =
          results.map((e) => toEventActivity(e)).toList();
      if (eventActivityList.isNotEmpty) {
        log('Success in getDefaultActivity');
        return eventActivityList;
      }
    } else {
      log('Error in getDefaultEventActivity: ${response.error!.message}');
    }
    return [];
  }

  void sortByCost(List<EventActivity> list) async {
    list.sort(((a, b) => a.cost.compareTo(b.cost)));
  }

  void sortByDistance(List<EventActivity> list) async {
    list.sort(((a, b) => a.distance.compareTo(b.distance)));
    /*final response = await _client
        .from('events_activities')
        .select()
        .match({'event_id': eventID}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventActivity> eventActivityList =
          results.map((e) => toEventActivity(e)).toList();
      eventActivityList.sort(((a, b) => a.distance.compareTo(b.distance)));

      List<Activity> newList = [];
      for (EventActivity eventActivity in eventActivityList) {
        print('activity name ${eventActivity.activityID}');
        var activity = (await getActivityFromID(eventActivity.activityID))[0];
        newList.add(activity);
      }
      log('Success in sortByDistance');
      return newList;
    } else {
      log('Error in sortByDistance: ${response.error!.message}');
    }
    return [];*/
  }

  /*Future<List<Activity>> getActivityFromID(String id) async {
    final response = await _client
        .from('activities')
        .select()
        .match({'activity_id': id}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<Activity> activity = results.map((e) => toActivity(e)).toList();
      return activity;
    } else {
      log('Error in getActivityFromID: ${response.error!.message}');
    }
    return [];
  }*/

  Activity toActivity(Map<String, dynamic> result) {
    return Activity(
      result['activity_id'],
      result['name'],
      result['location'],
      result['cost'],
      result['description'],
      result['latitude'],
      result['longitude'],
    );
  }

  EventActivity toEventActivity(Map<String, dynamic> result) {
    return EventActivity(
      result['activity_id'],
      result['event_id'],
      result['activity_name'],
      result['activity_description'],
      result['distance'],
      result['cost'],
      result['is_confirmed'],
    );
  }
}
