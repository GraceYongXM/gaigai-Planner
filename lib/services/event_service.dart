import 'dart:developer';
import 'package:supabase/supabase.dart';

import '../models/event_details.dart';

class EventService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  void createEvent(String name, String? description, DateTime startDate,
      DateTime endDate) async {
    var response = await _client.from('events_details').insert({
      'name': name,
      'description': description,
      'start_date': '${startDate.month}/${startDate.day}/${startDate.year}',
      'end_date': '${endDate.month}/${endDate.day}/${endDate.year}'
    }).execute();
    if (response.error == null) {
      log('success in createEvent');
    } else {
      log('Error in createEvent: ${response.error!.message}');
    }
  }

  EventDetails toEvent(Map<String, dynamic> result) {
    return EventDetails(
      result['event_id'],
      result['name'],
      result['description'],
      DateTime.parse(result['start_date']),
      DateTime.parse(result['end_date']),
    );
  }
}
