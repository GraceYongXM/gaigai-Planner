import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'models/user.dart' as u;
import 'pages/login_page.dart';
import 'pages/home_page.dart';

const String supabaseUrl = "https://spyrneyialbtrwiznbyk.supabase.co";
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNweXJuZXlpYWxidHJ3aXpuYnlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQyNzY0MzEsImV4cCI6MTk2OTg1MjQzMX0.37N041KOWVkIsL2fW2vo1heYgyBCs0sYxr3uyLhhuT0";

class SupabaseManager {
  final client = SupabaseClient(supabaseUrl, token);

  Future<void> signUpUser(context,
      {required String username,
      required String phone,
      required String email,
      required String password}) async {
    debugPrint("phone:$phone password:$password");
    final result = await client.auth.signUp(phone, password);

    debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      client.from('users').insert(
          {'username': username, 'mobileno': phone, 'email': email}).execute();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('You have created an account!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pushReplacementNamed(context, 'login');
    } else if (result.error?.message != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text('${result.error!.message}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> signInUser(context,
      {required String username, required String password}) async {
    debugPrint("username:$username password:$password");
    var user = await client
        .from('users')
        .select()
        .filter('username', 'in', username)
        .execute();
    var phoneNo = user.data;
    debugPrint("phone:$phoneNo");
    final result = await client.auth.signIn(phone: phoneNo, password: password);
    debugPrint(result.data!.toJson().toString());

    if (result.data != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Login Success!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user as User),
        ),
      );*/
    } else if (result.error?.message != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('Error:${result.error!.message.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> logout(context) async {
    await client.auth.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }
}
