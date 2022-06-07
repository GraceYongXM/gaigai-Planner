import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://spyrneyialbtrwiznbyk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNweXJuZXlpYWxidHJ3aXpuYnlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQyNzY0MzEsImV4cCI6MTk2OTg1MjQzMX0.37N041KOWVkIsL2fW2vo1heYgyBCs0sYxr3uyLhhuT0',
  );
  runApp(GaigaiPlanner());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color(0xffBB86FC),
  secondary: Color(0xff03DAC6),
  surface: Colors.white,
  background: Colors.white,
  error: Color(0xffCF6679),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.blue,
  onBackground: Colors.blue,
  onError: Color(0xff000000),
  brightness: Brightness.light,
);

class GaigaiPlanner extends StatelessWidget {
  const GaigaiPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity List',
      theme: ThemeData(
        colorScheme: defaultColorScheme,
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Login UI'),
      //home: ActivityListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
