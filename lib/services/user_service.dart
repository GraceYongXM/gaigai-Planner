import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart' as model;

const String supabaseUrl = "https://xvjretabvavhxqyaftsr.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU";

class UserService {
  static const users = 'users';

  final _client = SupabaseClient(supabaseUrl, token);

  Future<model.User?> getUser(String username) async {
    log('username $username');
    final response =
        await _client.from(users).select().eq('username', username).execute();
    if (response.error == null && response.data != null) {
      final results = response.data as List<dynamic>;
      if (results.isNotEmpty) {
        return results.map((e) => toUser(e)).toList()[0];
      }
    } else {
      log('Error in getUser: ${response.error!.message}');
    }
    return null;
  }

  Future<bool> uniqueUsername(String username) async {
    final response =
        await _client.from(users).select().eq('username', username).execute();
    if (response.error == null && response.data != null) {
      final results = response.data as List<dynamic>;
      return results.isEmpty;
    } else {
      log('Error uniqueUsername: ${response.error!.message}');
      return false;
    }
  }

  Future<bool> uniqueNumber(String number) async {
    final response =
        await _client.from(users).select().eq('mobileNo', number).execute();
    if (response.error == null && response.data != null) {
      final results = response.data as List<dynamic>;
      return results.isEmpty;
    } else {
      log('Error uniqueNumber: ${response.error!.message}');
      return false;
    }
  }

  Future<bool> uniqueEmail(String email) async {
    final response =
        await _client.from(users).select().eq('email', email).execute();
    if (response.error == null && response.data != null) {
      final results = response.data as List<dynamic>;
      return results.isEmpty;
    } else {
      log('Error uniqueEmail: ${response.error!.message}');
      return false;
    }
  }

  Future<List<model.User>> getUserFromID(String id) async {
    final response = await _client.from(users).select().eq('id', id).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => toUser(e)).toList();
    }
    log('Error getUserFromID: ${response.error!.message}');
    return [];
  }

  void insertUser(String username, String phone, String email) async {
    var response = await _client.from('users').insert({
      'username': username,
      'mobileNo': phone,
      'email': email,
      'display_name': username,
      'bio': '',
    }).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error inserting user: ${response.error!.message}');
    }
  }

  model.User toUser(Map<String, dynamic> result) {
    return model.User(
      result['id'],
      result['username'],
      result['mobileNo'],
      result['email'],
      result['display_name'],
      result['bio'],
      DateTime.parse(result['createTime']),
    );
  }

  void updateUsername(String newUsername, String oldUsername) async {
    var response = await _client.from(users).update(
        {'username': newUsername}).match({'username': oldUsername}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error updating username: ${response.error!.message}');
    }
  }

  void updateDisplayName(String newDisplayName, String oldDisplayName) async {
    var response = await _client
        .from(users)
        .update({'display_name': newDisplayName}).match(
            {'display_name': oldDisplayName}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error updating display name: ${response.error!.message}');
    }
  }

  void updateEmail(String newEmail, String oldEmail) async {
    var response = await _client
        .from(users)
        .update({'email': newEmail}).match({'email': oldEmail}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error updating email: ${response.error!.message}');
    }
  }

  void updateBio(String newBio, String oldBio) async {
    var response = await _client
        .from(users)
        .update({'bio': newBio}).match({'bio': oldBio}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error updating bio: ${response.error!.message}');
    }
  }

  void updateMobileNo(String newMobileNo, String oldMobileNo) async {
    var response = await _client.from(users).update(
        {'mobileNo': newMobileNo}).match({'mobileNo': oldMobileNo}).execute();
    if (response.error == null) {
      log('success');
    } else {
      log('Error updating mobileNo: ${response.error!.message}');
    }
  }
}
