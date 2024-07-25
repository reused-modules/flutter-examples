import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';

class GenaiWorker {
  late final GenerativeModel _model;
  final List<ChatContent> _content = [];

  final StreamController<List<ChatContent>> _streamController =
      StreamController.broadcast();
  Stream<List<ChatContent>> get stream => _streamController.stream;

  GenaiWorker() {
    final apiKey = 'AIzaSyCMtXxuosGM85jq-lhxfgDlXc-1SHbuMxM';

    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }

  void sendToGenmini(String message) async {
    _content.add(ChatContent.user(message));
    _streamController.sink.add(_content);
    try {
      final response = await _model.generateContent({Content.text(message)});

      final String? text = response.text;

      if (text == null) {
        _content.add(ChatContent.gemini('Unable to response'));
      } else {
        _content.add(ChatContent.gemini(text));
      }
    } catch (e) {
      _content.add(ChatContent.gemini('Unable to response'));
    }
  }
}

enum Sender { user, gemini }

class ChatContent {
  final Sender sender;
  final String message;

  ChatContent.user(this.message) : sender = Sender.user;
  ChatContent.gemini(this.message) : sender = Sender.gemini;
}
