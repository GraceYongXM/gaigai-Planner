import 'package:flutter/material.dart';

import 'package:gaigai_planner/models/event_activity.dart';

class IndivActivityPage extends StatefulWidget {
  const IndivActivityPage({super.key, required this.eventActivity});
  final EventActivity eventActivity;

  @override
  State<IndivActivityPage> createState() => _IndivActivityPageState();
}

class _IndivActivityPageState extends State<IndivActivityPage> {
  bool isReadMore = false;

  Widget readMore(String text) {
    final maxLines = isReadMore ? null : 3;
    return Text(
      text,
      style: const TextStyle(fontSize: 15),
      maxLines: maxLines,
      overflow: isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventActivity.activityName),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Activity Description:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: readMore(widget.eventActivity.activityDescription),
        ),
        ElevatedButton(
          onPressed: (() {
            setState(() {
              isReadMore = !isReadMore;
            });
          }),
          child: Text(isReadMore ? 'Read Less' : 'Read More'),
        ),
        Text('Cost: \$${widget.eventActivity.cost}'),
        Text(
            'Distance: ${double.parse((widget.eventActivity.distance).toStringAsFixed(2))}km'),
      ]),
    );
  }
}
