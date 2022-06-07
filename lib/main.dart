import 'package:flutter/material.dart';
import 'package:gaigai_planner/pages/home_page.dart';
import 'package:gaigai_planner/pages/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xvjretabvavhxqyaftsr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU',
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
      title: 'gaigaiPlanner',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginPage(title: 'Login UI'),
        '/signup': (_) => const RegisterPage(title: 'Register UI'),
      },
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
