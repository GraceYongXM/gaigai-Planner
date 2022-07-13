import 'package:flutter/material.dart';

import 'package:gaigai_planner/models/event_details.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.event});
  final EventDetails event;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        centerTitle: true,
      ),
    );
  }
}
