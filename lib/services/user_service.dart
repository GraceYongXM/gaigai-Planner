import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart' as model;

class UserService {
  static const users = 'users';

  final SupabaseClient _client;

  UserService(this._client);

  Future<List<model.User>> getUsers() async {
    final response = await _client.from(users).select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => toUser(e)).toList();
    }
    log('Error fetching notes: ${response.error!.message}');
    return [];
  }

  model.User toUser(Map<String, dynamic> result) {
    return model.User(
      result['id'],
      result['username'],
      result['mobileno'],
      result['email'],
      DateTime.parse(result['createtime']),
    );
  }
}
