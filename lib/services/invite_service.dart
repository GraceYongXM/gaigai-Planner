import 'dart:developer';

import 'package:gaigai_planner/models/event_invitation.dart';
import 'package:gaigai_planner/services/user_service.dart';
import 'package:supabase/supabase.dart';
import 'package:gaigai_planner/models/user.dart' as model;

class InviteService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');
  final _userService = UserService();

  void sendEventInvite(
      String userID, String eventID, String requesterID, String status) async {
    var response = await _client.from('event_invitations').insert({
      'user_id': userID,
      'event_id': eventID,
      'requester_id': requesterID,
      'status': status,
    }).execute();
    if (response.error == null) {
      log('success in sendEventInvite');
    } else {
      log('Error in sendEventInvite: ${response.error!.message}');
    }
  }

  Future<bool> inviteExists(
      {required String eventID, String? username, String? mobileNo}) async {
    late String userID;
    if (username != null) {
      userID = (await fromUsernameToFriend(username))[0].id;
    } else if (mobileNo != null) {
      userID = (await fromMobileNoToFriend(mobileNo))[0].id;
    }

    final response = await _client.from('event_invitations').select().match({
      'event_id': eventID,
      'user_id': userID,
    }).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventInvitation> eventDetails =
          results.map((e) => toEventInvitation(e)).toList();
      if (eventDetails.isNotEmpty) {
        return true;
      }
    } else {
      log('Error in inviteExists: ${response.error!.message}');
    }
    return false;
  }

  Future<List<model.User>> fromMobileNoToFriend(String mobileNo) async {
    final mobileNoResponse =
        await _client.from('users').select().eq('mobileNo', mobileNo).execute();
    if (mobileNoResponse.error == null) {
      final mobileNoResults = mobileNoResponse.data as List<dynamic>;
      List<model.User> user =
          mobileNoResults.map((e) => _userService.toUser(e)).toList();
      if (user.isNotEmpty) {
        return user;
      }
    } else {
      log('Error in fromMobileNoToFriend: ${mobileNoResponse.error!.message}');
    }
    return [];
  }

  Future<List<model.User>> fromUsernameToFriend(String username) async {
    final usernameResponse =
        await _client.from('users').select().eq('username', username).execute();
    if (usernameResponse.error == null) {
      final usernameResults = usernameResponse.data as List<dynamic>;
      List<model.User> user =
          usernameResults.map((e) => _userService.toUser(e)).toList();
      if (user.isNotEmpty) {
        return user;
      }
    } else {
      log('Error in fromUsernameToFriend: ${usernameResponse.error!.message}');
    }
    return [];
  }

  Future<List<model.User>> getInvitedUsers(String eventID) async {
    List<model.User> invitedUsers = [];

    final response = await _client // exclude owner
        .from('event_invitations')
        .select()
        .eq('event_id', eventID)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventInvitation> eventInvitation =
          results.map((e) => toEventInvitation(e)).toList();
      if (eventInvitation.isNotEmpty) {
        for (var i = 0; i < eventInvitation.length; i++) {
          invitedUsers.add(
              (await _userService.getUserFromID(eventInvitation[i].userID))[0]);
        }
        return invitedUsers;
      }
    } else {
      log('Error in getInvitedFriends: ${response.error!.message}');
    }
    return [];
  }

  EventInvitation toEventInvitation(Map<String, dynamic> result) {
    return EventInvitation(
      result['user_id'],
      result['event_id'],
      result['requester_id'],
      result['status'],
      DateTime.parse(result['request_date']),
    );
  }
}
