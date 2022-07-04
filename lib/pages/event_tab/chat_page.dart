import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/services/chat_service.dart';
import 'package:gaigai_planner/models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.eventDetails, required this.user})
      : super(key: key);
  final EventDetails eventDetails;
  final User user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _supabaseClient = ChatService();

  List<Message> messages = [];
  List<Widget> messageWidgets = [];

  bool isLoading = true;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose;
  }

  void getMessages() async {
    List<Message> _messages =
        await _supabaseClient.getMessages(widget.eventDetails.eventID);

    String? date = null;
    List<Widget> _messageWidgets = [];
    int index = 0;

    for (Message message in _messages) {
      String tempDate = DateFormat('yMMMd')
          .format(message.createTime.add(const Duration(hours: 8)));
      String tempTime = DateFormat.jm().format(message.createTime);

      if (date == null || date != tempDate) {
        _messageWidgets.add(DateTile(date: tempDate));
        date = tempDate;
      }
      if (index != _messages.length - 1 &&
          tempTime == DateFormat.jm().format(_messages[index + 1].createTime)) {
        if (message.userID == widget.user.id) {
          _messageWidgets.add(OwnMessageTileNoTime(message: message.content));
        } else {
          _messageWidgets.add(MessageTileNoTime(message: message.content));
        }
      } else {
        if (message.userID == widget.user.id) {
          _messageWidgets.add(OwnMessageTile(
              message: message.content, datetime: message.createTime));
        } else {
          _messageWidgets.add(MessageTile(
              message: message.content, datetime: message.createTime));
        }
      }
      index++;
    }

    if (this.mounted) {
      setState(() {
        messages = _messages;
        messageWidgets = _messageWidgets;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    void _scrollDown() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.small(
          onPressed: _scrollDown,
          child: const Icon(Icons.keyboard_arrow_down),
          backgroundColor: Color(0xffBB86FC),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: messageWidgets,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          if (_controller.text.trim() != '') {
                            DateTime now = DateTime.now();
                            _supabaseClient.insertMessage(
                                userID: widget.user.id,
                                eventID: widget.eventDetails.eventID,
                                content: _controller.text.trim());

                            setState(() {
                              messageWidgets.add(OwnMessageTile(
                                  message: _controller.text.trim(),
                                  datetime: now));
                              messages.add(Message(
                                  'random',
                                  widget.user.id,
                                  widget.eventDetails.eventID,
                                  _controller.text.trim(),
                                  now));
                            });
                          }
                          setState(() {
                            _controller.text = '';
                          });
                        },
                        icon: Icon(Icons.send),
                        color: Color(0xffBB86FC),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class OwnMessageTile extends StatelessWidget {
  String message;
  DateTime datetime;

  OwnMessageTile({
    Key? key,
    required this.message,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(message, style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat.jm().format(datetime.add(const Duration(hours: 8))),
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OwnMessageTileNoTime extends StatelessWidget {
  String message;

  OwnMessageTileNoTime({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(message, style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  String message;
  DateTime datetime;

  MessageTile({
    Key? key,
    required this.message,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat.jm().format(datetime.add(const Duration(hours: 8))),
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTileNoTime extends StatelessWidget {
  String message;

  MessageTileNoTime({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  String date;

  DateTile({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            date,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }
}
