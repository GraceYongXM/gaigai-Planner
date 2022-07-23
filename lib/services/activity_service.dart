import 'dart:developer';

import 'package:gaigai_planner/models/activity.dart';
import 'package:gaigai_planner/models/sortable_activity.dart';
import 'package:supabase/supabase.dart';

class ActivityService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<List<Activity>> getDefaultActivity() async {
    final response = await _client.from('activities').select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<Activity> activityList = results.map((e) => toActivity(e)).toList();
      if (activityList.isNotEmpty) {
        return activityList;
      }
    } else {
      log('Error in getDefaultActivity: ${response.error!.message}');
    }
    return [];
  }

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
}
