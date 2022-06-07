import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'pages/login_page.dart';

const String supabaseUrl = "https://spyrneyialbtrwiznbyk.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNweXJuZXlpYWxidHJ3aXpuYnlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQyNzY0MzEsImV4cCI6MTk2OTg1MjQzMX0.37N041KOWVkIsL2fW2vo1heYgyBCs0sYxr3uyLhhuT0";

class SupabaseManager {
  final client = SupabaseClient(supabaseUrl, token);

  Future<void> signUpUser(context,
      {String? username, String? phone, String? password}) async {
    debugPrint("phone:$phone password:$password");
    final result = await client.auth.signUp(phone!, password!);
    client
        .from('users')
        .insert({'username': username, 'mobileno': phone}).execute();

    debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('You have created an account!'),
        ),
      );
      Navigator.pushReplacementNamed(context, 'login');
    } else if (result.error?.message != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('Error:${result.error!.message.toString()}'),
        ),
      );
    }
  }

  Future<void> signInUser(context, {String? username, String? password}) async {
    debugPrint("username:$username password:$password");
    var phone = await client
        .from('users')
        .select('mobileno')
        .filter('username', 'in', username)
        .execute();
    var phoneNo = phone.toString();
    debugPrint("phone:$phoneNo");
    final result =
        await client.auth.signIn(phone: phoneNo, password: password!);
    debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Login Success!'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else if (result.error?.message != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('Error:${result.error!.message.toString()}'),
        ),
      );
    }
  }

  Future<void> logout(context) async {
    await client.auth.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }
}
