import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import './activitylist.dart';

void main() => runApp(GaigaiPlanner());

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
