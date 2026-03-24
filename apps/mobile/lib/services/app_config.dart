class AppConfig {
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.0-flash',
  );

  static bool get hasGeminiKey => geminiApiKey.trim().isNotEmpty;
}
