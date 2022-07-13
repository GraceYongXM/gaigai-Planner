import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gaigai_planner/models/event_details.dart';
import 'package:gaigai_planner/models/user.dart';
import 'package:gaigai_planner/services/chat_service.dart';
import 'package:gaigai_planner/models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.eventDetails,
    required this.user,
  }) : super(key: key);

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

  String? getName(String id, List<Map<String, String>> members) {
    for (Map<String, String> map in members) {
      if (map['id'] == id) {
        return map['display_name'];
      }
    }
    return null;
  }

  void getMessages() async {
    List<Message> _messages =
        await _supabaseClient.getMessages(widget.eventDetails.eventID);
    List<Map<String, String>> members =
        await _supabaseClient.getMembers(widget.eventDetails.eventID);

    String? date = null;
    List<Widget> _messageWidgets = [];
    String? name = null;
    int index = 0;

    for (Message message in _messages) {
      String tempDate = DateFormat('yMMMd')
          .format(message.createTime.add(const Duration(hours: 8)));
      String tempTime = DateFormat.jm().format(message.createTime);
      String tempName = getName(message.userID, members)!;

      if (date == null || date != tempDate) {
        _messageWidgets.add(DateTile(date: tempDate));
        date = tempDate;
      }

      if (message.userID == widget.user.id) {
        _messageWidgets.add(OwnMessageTile(message: message.content));
        name = tempName;
      } else {
        if (name == null || name != tempName) {
          _messageWidgets.add(
              MessageTileWithName(message: message.content, name: tempName));
          name = tempName;
        } else {
          _messageWidgets.add(MessageTile(message: message.content));
        }
      }
      if (index != _messages.length - 1 &&
          tempTime != DateFormat.jm().format(_messages[index + 1].createTime)) {
        _messageWidgets.add(TimeTile(
            datetime: message.createTime,
            right: message.userID == widget.user.id));
      } else if (index == _messages.length - 1) {
        _messageWidgets.add(TimeTile(
            datetime: message.createTime,
            right: message.userID == widget.user.id));
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
          backgroundColor: const Color(0xffBB86FC),
          child: const Icon(Icons.keyboard_arrow_down),
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
                              ));
                              messageWidgets
                                  .add(TimeTile(datetime: now, right: true));
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
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        },
                        icon: const Icon(Icons.send),
                        color: const Color(0xffBB86FC),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class TimeTile extends StatelessWidget {
  final DateTime datetime;
  final bool right;

  const TimeTile({Key? key, required this.datetime, required this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment:
            right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.jm().format(datetime.add(const Duration(hours: 8))),
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class OwnMessageTile extends StatelessWidget {
  final String message;

  const OwnMessageTile({
    Key? key,
    required this.message,
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;

  const MessageTile({
    Key? key,
    required this.message,
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTileWithName extends StatelessWidget {
  final String message;
  final String name;

  const MessageTileWithName({
    Key? key,
    required this.message,
    required this.name,
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(message, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final String date;

  const DateTile({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
