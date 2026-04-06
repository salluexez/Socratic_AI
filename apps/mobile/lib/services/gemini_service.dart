import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/chat_message.dart';
import '../models/subject.dart';
import 'app_config.dart';

class GeminiService {
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> sendMessage({
    required Subject subject,
    required List<ChatMessage> history,
    bool revealAnswer = false,
  }) async {
    if (!AppConfig.hasGeminiKey) {
      throw const GeminiException(
        'Gemini API key missing. Start the app with --dart-define=GEMINI_API_KEY=YOUR_KEY',
      );
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/${AppConfig.geminiModel}:generateContent',
    );

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': AppConfig.geminiApiKey,
      },
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {
              'text': _systemPrompt(
                subject: subject.name,
                revealAnswer: revealAnswer,
              ),
            },
          ],
        },
        'contents': _toContents(history),
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 300,
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GeminiException(
        'Gemini request failed (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw const GeminiException('Gemini returned no response.');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw const GeminiException('Gemini returned an empty message.');
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      final text = (part as Map<String, dynamic>)['text'];
      if (text is String && text.trim().isNotEmpty) {
        if (buffer.isNotEmpty) buffer.writeln();
        buffer.write(text.trim());
      }
    }

    if (buffer.isEmpty) {
      throw const GeminiException('Gemini returned no text content.');
    }

    return buffer.toString();
  }

  List<Map<String, Object>> _toContents(List<ChatMessage> history) {
    return history.map((message) {
      final role = message.role == 'assistant' ? 'model' : 'user';
      return {
        'role': role,
        'parts': [
          {'text': message.content}
        ],
      };
    }).toList();
  }

  String _systemPrompt({
    required String subject,
    required bool revealAnswer,
  }) {
    if (revealAnswer) {
      return '''
You are a Socratic teaching assistant specializing in $subject.
The student has explicitly asked to see the final answer.
Provide the full solution clearly and explain the reasoning step by step so the student can learn from it.
Keep the answer concise and easy to follow.
''';
    }

    return '''
You are a Socratic teaching assistant specializing in $subject.
Do not give the final answer directly.
Ask one guiding question at a time.
Keep responses short, usually 2 to 4 sentences.
Encourage correct reasoning and gently redirect weak reasoning.
If the student is confused, simplify the next step.
''';
  }
}

class GeminiException implements Exception {
  const GeminiException(this.message);

  final String message;

  @override
  String toString() => message;
}
