import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:public_chat/wigets/chat_bubble_widget.dart';
import 'package:public_chat/wigets/message_box_widget.dart';
import 'package:public_chat/worker/genai_worker.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GenaiWorker _worker = GenaiWorker();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<ChatContent>>(
                    stream: _worker.stream,
                    builder: (context, snapshot) {
                      final List<ChatContent> data = snapshot.data ?? [];
                      return ListView(
                        children: data.map((e) {
                          final bool isMine = e.sender == Sender.user;
                          return ChatBubble(
                              isMine: isMine,
                              photoUrl: 'https://i.imgur.com/jILsecU.jpeg',
                              message: e.message);
                        }).toList(),
                      );
                    })),
            MessageBox(
              onSendMessage: (value) => {_worker.sendToGenmini(value)},
            )
          ],
        )),
      ),
    );
  }
}
