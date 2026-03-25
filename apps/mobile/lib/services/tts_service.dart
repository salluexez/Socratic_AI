import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService instance = TTSService._internal();
  final FlutterTts _flutterTts = FlutterTts();
  
  String? _currentlySpeakingId;
  bool _isSpeaking = false;

  TTSService._internal() {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentlySpeakingId = null;
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
      _currentlySpeakingId = null;
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      _currentlySpeakingId = null;
    });
  }

  String? get currentlySpeakingId => _currentlySpeakingId;
  bool get isSpeaking => _isSpeaking;

  Future<void> speak(String id, String text) async {
    if (_currentlySpeakingId == id && _isSpeaking) {
      await stop();
      return;
    }

    if (_isSpeaking) {
      await stop();
    }

    _currentlySpeakingId = id;
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _currentlySpeakingId = null;
  }
}
