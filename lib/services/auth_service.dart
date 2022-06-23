import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';
import '../models/user.dart' as model;

class AuthService {
  final GoTrueClient _client;
  static const supabaseSessionKey = 'supabase_session';

  final _supabaseClient = UserService();

  AuthService(this._client);

  Future<void> _persistSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    log('Persisting session string');
    await prefs.setString(supabaseSessionKey, session.persistSessionString);
  }

  Future<bool> signUp(String email, String password) async {
    final response = await _client.signUp(email, password);
    if (response.error == null) {
      log('Sign up was successful for user ID: ${response.user!.id}');
      //_persistSession(response.data!);
      return true;
    }
    log('Sign up error: ${response.error!.message}');
    return false;
  }

  Future<bool> signIn(String email, String password) async {
    final response = await _client.signIn(email: email, password: password);
    if (response.error == null) {
      log('Sign in was successful for user ID: ${response.user!.id}');
      _persistSession(response.data!);
      return true;
    }
    log('email: ${email} password: ${password}');
    log('Sign in error: ${response.error!.message}');
    return false;
  }

  Future<bool> signOut() async {
    final response = await _client.signOut();
    if (response.error == null) {
      return true;
    }
    log('Log out error: ${response.error!.message}');
    return false;
  }

  Future<bool> recoverSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(supabaseSessionKey)) {
      log('Found persisted session string, attempting to recover session');
      final jsonStr = prefs.getString(supabaseSessionKey)!;
      final response = await _client.recoverSession(jsonStr);
      if (response.error == null) {
        log('Session successfully recovered for user ID: ${response.user!.id}');
        _persistSession(response.data!);
        return true;
      }
    }
    return false;
  }

  Future<model.User?> recoverUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(supabaseSessionKey)) {
      final jsonStr = prefs.getString(supabaseSessionKey)!;
      final response = await _client.recoverSession(jsonStr);
      if (response.error == null) {
        var id = response.user!.id;
        model.User user = (await _supabaseClient.getUserFromID(id))[0];
        return user;
      }
      return null;
    }
  }

  Future<bool> updateUserEmail(String email) async {
    final response = await _client.update(UserAttributes(email: email));
    if (response.error == null) {
      log('Email update was successful for user ID: ${response.user!.id}');
      return true;
    }
    log('Update email error: ${response.error!.message}');
    return false;
  }

  Future<bool> updateUserPassword(String password) async {
    final response = await _client.update(UserAttributes(password: password));
    if (response.error == null) {
      log('Password update was successful for user ID: ${response.user!.id}');
      return true;
    }
    log('Update password error: ${response.error!.message}');
    return false;
  }
}
