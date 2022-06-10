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
      log('Error fetching notes: ${response.error!.message}');
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
      log('Error fetching notes: ${response.error!.message}');
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
      log('Error fetching notes: ${response.error!.message}');
      return false;
    }
  }

  Future<List<model.User>> getUserFromID(String id) async {
    final response = await _client.from(users).select().eq('id', id).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => toUser(e)).toList();
    }
    log('Error fetching notes: ${response.error!.message}');
    return [];
  }

  void insertUser(String username, String phone, String email) async {
    var response = await _client.from('users').insert({
      'username': username,
      'mobileNo': phone,
      'email': email,
    }).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      log('success');
    } else {
      log('Error creating note: ${response.error!.message}');
    }
  }

  model.User toUser(Map<String, dynamic> result) {
    return model.User(
      result['id'],
      result['username'],
      result['mobileNo'],
      result['email'],
      DateTime.parse(result['createTime']),
    );
  }
}
