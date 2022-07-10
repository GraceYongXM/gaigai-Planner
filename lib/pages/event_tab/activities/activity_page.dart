import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.name});
  final String name;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
    );
  }
}
