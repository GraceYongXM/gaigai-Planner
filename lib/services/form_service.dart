import 'dart:developer';

import 'package:supabase/supabase.dart';

class FormService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<bool> isFormDone(String userID, String eventID) async {
    final response = await _client
        .from('form_dates')
        .select()
        .match({'user_id': userID, 'event_id': eventID}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      if (results.isNotEmpty) {
        log('isFormDone success');
        return true;
      }
    } else {
      log('Error in isFormDone: ${response.error!.message}');
    }
    return false;
  }

  void updateLocation(String userID, String eventID, String location) async {
    final response = await _client
        .from('events_users')
        .update({'location': location}).match(
            {'user_id': userID, 'event_id': eventID}).execute();
    if (response.error == null) {
      log('updateLocation success');
    } else {
      log('Error in updateLocation: ${response.error!.message}');
    }
  }
}
