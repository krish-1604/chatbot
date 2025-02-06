import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test/models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final GenerativeModel _model;
  bool _isLoading = false;

  ChatProvider() : _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyDAHWEaPH9hClSPEOfoR78NRW-LFvzq2bg',
  );

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final prompt = Content.text(content);
      final response = await _model.generateContent([prompt]);
      final responseText = response.text ?? 'Sorry, I could not generate a response.';

      _messages.add(ChatMessage(
        content: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        content: 'Error: Unable to get response. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}