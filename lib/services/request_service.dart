import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart' as model;
import '../models/event_details.dart';
import '../models/friend_request.dart';
import '../models/event_invitation.dart';
import 'user_service.dart';

class RequestService {
  final _supabaseClient = UserService();
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<bool> friendExists(
      {required List<String> friendIDs,
      String? mobileNo,
      String? username}) async {
    String toID;
    if (mobileNo != null) {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('mobileNo', mobileNo)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    } else {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('username', username)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    }
    return friendIDs.contains(toID);
  }

  void updateRequest(
      {required String fromID,
      required String toID,
      required bool accepted}) async {
    String status = 'rejected';
    if (accepted) {
      status = 'accepted';
      final insert1 = await _client.from('friends').insert({
        'id': fromID,
        'friend_id': toID,
      }).execute();
      log(insert1.error == null
          ? 'insert1 success'
          : 'Error in insert1: ${insert1.error!.message}');

      final insert2 = await _client.from('friends').insert({
        'id': toID,
        'friend_id': fromID,
      }).execute();
      log(insert2.error == null
          ? 'insert2 success'
          : 'Error in insert2: ${insert2.error!.message}');
    }
    final response = await _client
        .from('friend_requests')
        .update({'status': status})
        .eq('to_id', toID)
        .eq('from_id', fromID)
        .execute();
    log(response.error == null
        ? 'updateRequest success'
        : 'Error in updateRequest: ${response.error!.message}');
  }

  Future<bool?> requestExists(
      {required String fromID, String? mobileNo, String? username}) async {
    String toID;
    if (mobileNo != null) {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('mobileNo', mobileNo)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    } else {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('username', username)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    }
    var response = await _client
        .from('friend_requests')
        .select()
        .eq('from_id', fromID)
        .eq('to_id', toID)
        .eq('status', 'pending')
        .execute();
    var response2 = await _client
        .from('friend_requests')
        .select()
        .eq('from_id', toID)
        .eq('to_id', fromID)
        .eq('status', 'pending')
        .execute();
    var list1 = response.data as List<dynamic>;
    var list2 = response2.data as List<dynamic>;
    if (list2.isNotEmpty) {
      return null;
    } else if (list1.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void insertRequest(
      {required String fromID, String? mobileNo, String? username}) async {
    String toID;
    if (mobileNo != null) {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('mobileNo', mobileNo)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    } else {
      var results = (await _client
              .from('users')
              .select('id')
              .eq('username', username)
              .execute())
          .data as List<dynamic>;
      toID = results.map((e) => e['id']).toList()[0];
    }
    var response = await _client.from('friend_requests').insert({
      'from_id': fromID,
      'to_id': toID,
    }).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error in insertRequest: ${response.error!.message}');
    }
  }

  Future<List<String>> getIDsOfRequests(String id) async {
    final response = await _client
        .from('friend_requests')
        .select('from_id')
        .eq('to_id', id)
        .eq('status', 'pending')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> requestIDs =
          results.map((e) => e['from_id'] as String).toList();
      if (requestIDs.isNotEmpty) {
        return requestIDs;
      }
    } else {
      log('Error in getIDsOfRequests: ${response.error!.message}');
    }
    return [];
  }

  Future<List<FriendRequest>> getRequests(String id) async {
    final response = await _client
        .from('friend_requests')
        .select()
        .eq('to_id', id)
        .eq('status', 'pending')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<FriendRequest> requestDates =
          results.map((e) => toRequest(e)).toList();
      if (requestDates.isNotEmpty) {
        return requestDates;
      }
    } else {
      log('Error in getRequestDates: ${response.error!.message}');
    }
    return [];
  }

  Future<List<model.User>> getRequesterInfo(List<String> requestIDs) async {
    final response =
        await _client.from('users').select().in_('id', requestIDs).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<model.User> requesterInfo =
          results.map((e) => _supabaseClient.toUser(e)).toList();
      if (requesterInfo.isNotEmpty) {
        return requesterInfo;
      }
    } else {
      log('Error in getRequesterInfo: ${response.error!.message}');
    }
    return [];
  }

  Future<List<String>> getEventIDs(String id) async {
    final response = await _client
        .from('event_invitations')
        .select('event_id')
        .eq('user_id', id)
        .eq('status', 'pending')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> eventIDs =
          results.map((e) => e['event_id'] as String).toList();
      if (eventIDs.isNotEmpty) {
        return eventIDs;
      }
    } else {
      log('Error in getEventIds: ${response.error!.message}');
    }
    return [];
  }

  Future<List<EventInvitation>> getInvitations(String id) async {
    final response = await _client
        .from('event_invitations')
        .select()
        .eq('user_id', id)
        .eq('status', 'pending')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventInvitation> invitationDates =
          results.map((e) => toInvitation(e)).toList();
      if (invitationDates.isNotEmpty) {
        return invitationDates;
      }
    } else {
      log('Error in getInvitationDates: ${response.error!.message}');
    }
    return [];
  }

  Future<List<EventDetails>> getEventInfo(List<String> invitationIDs) async {
    final response = await _client
        .from('events_details')
        .select()
        .in_('event_id', invitationIDs)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventDetails> eventInfo = results.map((e) => toEvent(e)).toList();
      if (eventInfo.isNotEmpty) {
        return eventInfo;
      }
    } else {
      log('Error in getEventInfo: ${response.error!.message}');
    }
    return [];
  }

  FriendRequest toRequest(Map<String, dynamic> result) {
    return FriendRequest(
      result['id'],
      result['from_id'],
      result['to_id'],
      result['status'],
      DateTime.parse(result['request_date']),
    );
  }

  EventInvitation toInvitation(Map<String, dynamic> result) {
    return EventInvitation(
      result['user_id'],
      result['event_id'],
      result['status'],
      DateTime.parse(result['request_date']),
    );
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
