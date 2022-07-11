import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.name"),
        centerTitle: true,
      ),
    );
  }
}
