class AppConfig {
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.0-flash',
  );
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static bool get hasGeminiKey => geminiApiKey.trim().isNotEmpty;
  static bool get hasApiBaseUrl => apiBaseUrl.trim().isNotEmpty;
}
