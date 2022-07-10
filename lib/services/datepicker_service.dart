import 'dart:developer';

import 'package:supabase/supabase.dart';

class DatePickerService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

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
}
