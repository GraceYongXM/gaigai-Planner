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

  void updateInvitation(
      {required String eventID,
      required String userID,
      required bool accepted}) async {
    String status = 'rejected';
    if (accepted) {
      status = 'accepted';
      final insert1 = await _client.from('events_users').insert({
        'event_id': eventID,
        'user_id': userID,
      }).execute();
      log(insert1.error == null
          ? 'insert1 success'
          : 'Error in insert1: ${insert1.error!.message}');
    }
    final response = await _client
        .from('event_invitations')
        .update({'status': status})
        .eq('user_id', userID)
        .eq('event_id', eventID)
        .execute();
    log(response.error == null
        ? 'updateInvitation success'
        : 'Error in updateInvitation: ${response.error!.message}');
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

  Future<String?> findUsername(String mobileNo) async {
    var response = await _client
        .from('users')
        .select('username')
        .eq('mobileNo', mobileNo)
        .execute();
    if (response.error == null) {
      final result = response.data as List<dynamic>;
      log('findUsername success');
      return result[0]['username'];
    } else {
      log('Error in findUsername: ${response.error!.message}');
      return null;
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
    List<model.User> requesterInfo = [];
    for (String id in requestIDs) {
      final response =
          await _client.from('users').select().eq('id', id).execute();
      if (response.error == null) {
        final user = response.data as List<dynamic>;
        requesterInfo.add(_supabaseClient.toUser(user[0]));
      } else {
        log('Error in getRequesterInfo: ${response.error!.message}');
      }
    }
    if (requesterInfo.isNotEmpty) {
      return requesterInfo;
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
    List<EventDetails> eventInfo = [];
    for (String id in invitationIDs) {
      final response = await _client
          .from('events_details')
          .select()
          .eq('event_id', id)
          .execute();
      if (response.error == null) {
        final event = response.data as List<dynamic>;
        eventInfo.add(toEvent(event[0]));
      } else {
        log('Error in getEventInfo: ${response.error!.message}');
      }
    }
    if (eventInfo.isNotEmpty) {
      return eventInfo;
    }
    return [];
  }

  Future<List<String>> getOwnerIDs(String id) async {
    final response = await _client
        .from('event_invitations')
        .select('requester_id')
        .eq('user_id', id)
        .eq('status', 'pending')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> requesterIDs =
          results.map((e) => e['requester_id'] as String).toList();
      if (requesterIDs.isNotEmpty) {
        return requesterIDs;
      }
    } else {
      log('Error in getOwnerIDs: ${response.error!.message}');
    }
    return [];
  }

  Future<List<String>> getOwnerNames(List<String> requesterIDs) async {
    List<String> ownerNames = [];
    for (String id in requesterIDs) {
      final response = await _client
          .from('users')
          .select('display_name')
          .eq('id', id)
          .execute();
      if (response.error == null) {
        final name = response.data as List<dynamic>;
        ownerNames.add(name[0]['display_name']);
      } else {
        log('Error in getOwnerNames: ${response.error!.message}');
      }
    }
    if (ownerNames.isNotEmpty) {
      return ownerNames;
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
      result['id'],
      result['user_id'],
      result['event_id'],
      result['requester_id'],
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
