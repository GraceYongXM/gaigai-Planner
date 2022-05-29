import 'package:flutter/material.dart';

import './activitylist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ActivityListPage(),
    );
  }
}
