import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_details.dart';
import 'package:gaigai_planner/models/message.dart';

class ChatService {
  final _client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');

  Future<void> deleteForms(String eventID) async {
    final response = await _client
        .from('form_dates')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    final response2 = await _client
        .from('events_users')
        .update({'location': null})
        .eq('event_id', eventID)
        .execute();
    if (response.error != null) {
      log(response.error!.message);
    }
    if (response2.error != null) {
      log(response2.error!.message);
    }
  }

  Future<List<DateTime>> getCommonDates(DateTime startDate, DateTime endDate,
      String eventID, int numOfMembers) async {
    DateTime date = startDate;
    List<DateTime> commonDates = [];
    while (date.year != endDate.year ||
        date.month != endDate.month ||
        date.day != endDate.day) {
      final response = await _client.from('form_dates').select().match({
        'event_id': eventID,
        'date': '${date.month}/${date.day}/${date.year}'
      }).execute();
      if (response.error == null) {
        final results = response.data as List<dynamic>;
        if (results.length == numOfMembers) {
          commonDates.add(DateTime(date.year, date.month, date.day));
        }
      }
      date = date.add(const Duration(days: 1));
    }

    final response = await _client.from('form_dates').select().match({
      'event_id': eventID,
      'date': '${date.month}/${date.day}/${date.year}'
    }).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      if (results.length == numOfMembers) {
        commonDates.add(DateTime(date.year, date.month, date.day));
      }
    }
    return commonDates;
  }

  Future<List<Map<String, String>>> getMembers(String eventID) async {
    final response = await _client
        .from('events_users')
        .select('user_id')
        .eq('event_id', eventID)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<String> userIDs =
          results.map((e) => e['user_id'] as String).toList();
      List<Map<String, String>> members = [];
      for (String id in userIDs) {
        final response2 = await _client
            .from('users')
            .select('display_name')
            .eq('id', id)
            .execute();
        String name = (response2.data as List<dynamic>)[0]['display_name'];
        members.add({'id': id, 'display_name': name});
      }
      return members;
    } else {
      log('${response.error}');
      return [];
    }
  }

  void insertMessage(
      {required String userID,
      required String eventID,
      required String content}) async {
    var response = await _client.from('messages').insert({
      'user_id': userID,
      'event_id': eventID,
      'content': content,
    }).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error in insertMessage: ${response.error!.message}');
    }
  }

  Future<List<Message>> getMessages(String eventID) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('event_id', eventID)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<Message> messages = results
          .map((e) => Message(
                e['id'],
                e['user_id'],
                e['event_id'],
                e['content'],
                DateTime.parse(e['create_time']),
              ))
          .toList();
      if (messages.isNotEmpty) {
        log('getMessages success');
        return messages;
      }
      return [];
    } else {
      log('error in getMessages:${response.error}');
      return [];
    }
  }

  Future<bool> uniqueEventName(String name, String id) async {
    final response = await _client
        .from('events_details')
        .select('name')
        .match({'name': name, 'owner_id': id}).execute();
    if (response.error == null && response.data != null) {
      final results = response.data as List<dynamic>;
      return results.isEmpty;
    } else {
      log('Error uniqueEventName: ${response.error!.message}');
      return false;
    }
  }

  Future<EventDetails?> getEvent(String eventID) async {
    final response = await _client
        .from('events_details')
        .select()
        .eq('event_id', eventID)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      List<EventDetails> eventInfo = results
          .map((e) => EventDetails(
                e['event_id'],
                e['owner_id'],
                e['name'],
                e['description'],
                DateTime.parse(e['start_date']),
                DateTime.parse(e['end_date']),
              ))
          .toList();
      if (eventInfo.isNotEmpty) {
        return eventInfo[0];
      }
    } else {
      log('Error in getEvent: ${response.error!.message}');
    }
    return null;
  }

  Future<void> deleteEvent({required String eventID}) async {
    final delete1 = await _client
        .from('events_details')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    log(delete1.error == null
        ? 'delete1 success'
        : 'Error in delete1: ${delete1.error!.message}');

    final delete2 = await _client
        .from('events_users')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    log(delete2.error == null
        ? 'delete2 success'
        : 'Error in delete2: ${delete2.error!.message}');

    final delete3 = await _client
        .from('events_activities')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    log(delete3.error == null
        ? 'delete3 success'
        : 'Error in delete3: ${delete3.error!.message}');

    final delete4 = await _client
        .from('event_invitations')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    log(delete4.error == null
        ? 'delete4 success'
        : 'Error in delete4: ${delete4.error!.message}');

    final delete5 = await _client
        .from('form_dates')
        .delete(returning: ReturningOption.minimal)
        .eq('event_id', eventID)
        .execute();
    log(delete5.error == null
        ? 'delete5 success'
        : 'Error in delete5: ${delete5.error!.message}');
  }

  Future<void> updateEvent(
      {required String id,
      required String name,
      required String? description,
      required DateTime startDate,
      required DateTime endDate}) async {
    var response = await _client.from('events_details').update({
      'name': name,
      'description': description,
      'start_date': '${startDate.month}/${startDate.day}/${startDate.year}',
      'end_date': '${endDate.month}/${endDate.day}/${endDate.year}'
    }).match({'event_id': id}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error in updateEvent: ${response.error!.message}');
    }
  }

  Future<String?> getOwner(String id) async {
    final response = await _client
        .from('users')
        .select('display_name')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final name = response.data as List<dynamic>;
      return name[0]['display_name'];
    } else {
      log('Error in getOwner: ${response.error!.message}');
      return null;
    }
  }
}
