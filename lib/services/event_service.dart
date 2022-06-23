import 'dart:developer';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

import '../models/event_details.dart';

class EventService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<String> createEvent(String name, String ownerID, String? description,
      DateTime startDate, DateTime endDate) async {
    var response = await _client.from('events_details').insert({
      'name': name,
      'owner_id': ownerID,
      'description': description,
      'start_date': '${startDate.month}/${startDate.day}/${startDate.year}',
      'end_date': '${endDate.month}/${endDate.day}/${endDate.year}'
    }).execute();
    if (response.error == null) {
      log('success in createEvent');
    } else {
      log('Error in createEvent: ${response.error!.message}');
    }
    var eventID = await getEventID(ownerID, name);
    log('eventID in createEvent: $eventID');
    addOwnerToEvent(eventID, ownerID);
    return eventID;
  }

  Future<String> getEventID(String ownerID, String name) async {
    final response = await _client
        .from('events_details')
        .select()
        .match({'owner_id': ownerID, 'name': name}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventDetails> eventInfo = results.map((e) => toEvent(e)).toList();
      if (eventInfo.isNotEmpty) {
        return eventInfo[0].eventID.toString();
      }
    } else {
      log('Error in getEventID: ${response.error!.message}');
    }
    return '';
  }

  void addOwnerToEvent(String eventID, String ownerID) async {
    var response = await _client.from('events_users').insert({
      'event_id': eventID,
      'user_id': ownerID,
    }).execute();
    if (response.error == null) {
      log('success in addOwnerToEvent');
    } else {
      log('Error in addOwnerToEvent: ${response.error!.message}');
    }
  }

  Future<List<EventDetails>> getEventDetails(String eventID) async {
    final response = await _client
        .from('events_details')
        .select()
        .eq('event_id', eventID)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventDetails> eventDetails = results.map((e) => toEvent(e)).toList();
      if (eventDetails.isNotEmpty) {
        return eventDetails;
      }
    } else {
      log('Error in getEventDetails: ${response.error!.message}');
    }
    return [];
  }

  EventDetails toEvent(Map<String, dynamic> result) {
    return EventDetails(
      result['event_id'],
      result['owner_id'],
      result['name'],
      result['description'],
      DateTime.parse(result['start_date']),
      DateTime.parse(result['end_date']),
    );
  }
}
