import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';
import '../models/friend.dart';
import '../models/user.dart' as model;

class FriendService {
  final _supabaseClient = UserService();
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  void deleteFriend(String fromID, String toID) async {
    final delete1 = await _client
        .from('friends')
        .delete(returning: ReturningOption.minimal)
        .eq('id', fromID)
        .eq('friend_id', toID)
        .execute();
    log(delete1.error == null
        ? 'delete1 success'
        : 'Error in delete1: ${delete1.error!.message}');

    final delete2 = await _client
        .from('friends')
        .delete(returning: ReturningOption.minimal)
        .eq('id', toID)
        .eq('friend_id', fromID)
        .execute();
    log(delete2.error == null
        ? 'delete2 success'
        : 'Error in delete2: ${delete2.error!.message}');
  }

  Future<List<String>> getFriendIDs(String id) async {
    final response = await _client
        .from('friends')
        .select('friend_id')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> friendIDs =
          results.map((e) => e['friend_id'] as String).toList();
      if (friendIDs.isNotEmpty) {
        return friendIDs;
      }
    } else {
      log('Error in getFriendIDs: ${response.error!.message}');
    }
    return [];
  }

  Future<List<Friend>> getFriends(String id) async {
    final response =
        await _client.from('friends').select().eq('id', id).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<Friend> friendDates = results.map((e) => toFriend(e)).toList();
      if (friendDates.isNotEmpty) {
        return friendDates;
      }
    } else {
      log('Error in getFriends: ${response.error!.message}');
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
      result['friend_id'],
      DateTime.parse(result['friend_time']),
    );
  }
}
