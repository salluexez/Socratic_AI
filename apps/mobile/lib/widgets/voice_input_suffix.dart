import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../theme/app_theme.dart';

class VoiceInputSuffix extends StatefulWidget {
  const VoiceInputSuffix({
    super.key,
    required this.controller,
    this.onListeningStarted,
    this.onListeningStopped,
  });

  final TextEditingController controller;
  final VoidCallback? onListeningStarted;
  final VoidCallback? onListeningStopped;

  @override
  State<VoiceInputSuffix> createState() => _VoiceInputSuffixState();
}

class _VoiceInputSuffixState extends State<VoiceInputSuffix> with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  late AnimationController _animationController;
  Timer? _silenceTimer;
  String _lastRecognizedWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _silenceTimer?.cancel();
    _speechToText.stop();
    super.dispose();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            widget.onListeningStopped?.call();
          }
        },
        onError: (error) {
          debugPrint('Speech error: $error');
          setState(() => _isListening = false);
          widget.onListeningStopped?.call();
        },
      );
      setState(() {});
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
    }
  }

  void _startListening() async {
    if (!_speechEnabled) {
      _initSpeech();
      return;
    }
    
    _lastRecognizedWords = '';
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10), // The plugin also has its own auto-pause
      cancelOnError: true,
      partialResults: true,
    );
    setState(() => _isListening = true);
    widget.onListeningStarted?.call();
    _resetSilenceTimer();
  }

  void _stopListening() async {
    _silenceTimer?.cancel();
    await _speechToText.stop();
    setState(() => _isListening = false);
    widget.onListeningStopped?.call();
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 2), () {
      if (_isListening) {
        _stopListening();
      }
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _resetSilenceTimer();
    
    final text = result.recognizedWords;
    if (text.isNotEmpty && text != _lastRecognizedWords) {
      final currentText = widget.controller.text;
      
      // If we are appending or replacing partial results
      // This is a simplified way to handle real-time results
      // We assume user is appending to the end for simplicity
      if (_lastRecognizedWords.isNotEmpty && currentText.endsWith(_lastRecognizedWords)) {
        widget.controller.text = currentText.substring(0, currentText.length - _lastRecognizedWords.length) + text;
      } else {
        widget.controller.text = currentText.isEmpty ? text : '$currentText $text';
      }
      
      _lastRecognizedWords = text;
      
      // Move cursor to end
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }

    if (result.finalResult) {
      _silenceTimer?.cancel();
      _stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (_isListening)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.primaryDim.withValues(alpha: 0.1 + (0.2 * _animationController.value)),
                ),
              ),
            if (_isListening)
              Container(
                width: 32 + (16 * _animationController.value),
                height: 32 + (16 * _animationController.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: palette.primaryDim.withValues(alpha: 0.5 * (1.0 - _animationController.value)),
                    width: 2,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: _isListening 
                  ? palette.primaryDim
                  : (_speechEnabled ? palette.textMuted : palette.textMuted.withValues(alpha: 0.3)),
              ),
              onPressed: () {
                if (!_speechEnabled) {
                  _initSpeech();
                } else if (_isListening) {
                  _stopListening();
                } else {
                  _startListening();
                }
              },
              tooltip: _isListening 
                ? 'Stop Listening' 
                : (!_speechEnabled ? 'Speech Recognition Initializing...' : 'Start Voice Typing'),
            ),
          ],
        );
      },
    );
  }
}
