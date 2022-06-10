import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';
import '../models/friend.dart';
import '../models/user.dart' as model;

class FriendService {
  final _supabaseClient = UserService();
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<List<String>> getFriendIDs(String id) async {
    final response = await _client
        .from('friends')
        .select('friend_id')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> friendIDs =
          results.map((e) => e['friendID'] as String).toList();
      if (friendIDs.isNotEmpty) {
        return friendIDs;
      }
    } else {
      log('Error in getFriendIDs: ${response.error!.message}');
    }
    return [];
  }

  Future<List<DateTime>> getFriendTimes(String id) async {
    final response = await _client
        .from('friends')
        .select('friend_time')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<DateTime> friendTimes =
          results.map((e) => DateTime.parse(e['friendTime'])).toList();
      if (friendTimes.isNotEmpty) {
        return friendTimes;
      }
    } else {
      log('Error in getFriendTimes: ${response.error!.message}');
    }
    return [];
  }

  Future<List<model.User>> getFriendInfo(List<String> friendIDs) async {
    final response =
        await _client.from('users').select().in_('id', friendIDs).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<model.User> friendsInfo =
          results.map((e) => _supabaseClient.toUser(e)).toList();
      if (friendsInfo.isNotEmpty) {
        return friendsInfo;
      }
    } else {
      log('Error in getFriendsInfo: ${response.error!.message}');
    }
    return [];
  }

  Friend toFriend(Map<String, dynamic> result) {
    return Friend(
      result['id'],
      result['friendID'],
      DateTime.parse(result['friendTime']),
    );
  }
}
