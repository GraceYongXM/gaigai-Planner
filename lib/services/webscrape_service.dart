import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = "https://xvjretabvavhxqyaftsr.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU";

class WebscrapeService {
  final _client = SupabaseClient(supabaseUrl, token);

  void insertActivity(
      {required String title,
      required String location,
      required double cost,
      required String description}) async {
    var result =
        await _client.from('activities').select().eq('name', title).execute();
    if ((result.data as List<dynamic>).isEmpty) {
      var response = await _client.from('activities').insert({
        'name': title,
        'location': location,
        'cost': cost,
        'description': description,
      }).execute();
      if (response.error == null) {
        log('success');
      } else {
        log('Error inserting activity: ${response.error!.message}');
      }
    }
  }

  Future<bool> dataExists() async {
    var response = await _client.from('activities').select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.isNotEmpty;
    } else {
      log('Error uniqueUsername: ${response.error!.message}');
      return false;
    }
  }
}
