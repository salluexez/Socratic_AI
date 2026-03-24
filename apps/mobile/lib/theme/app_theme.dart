import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.surfaceLow,
    required this.surfaceCard,
    required this.primaryDim,
    required this.primaryContainer,
    required this.secondaryContainer,
    required this.tertiaryContainer,
    required this.text,
    required this.textMuted,
    required this.outline,
    required this.success,
    required this.heroBackground,
    required this.primaryGradient,
    required this.chipBackground,
    required this.orbTop,
    required this.orbBottom,
    required this.inputBar,
    required this.surfaceElevated,
  });

  final Color surfaceLow;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color primaryDim;
  final Color primaryContainer;
  final Color secondaryContainer;
  final Color tertiaryContainer;
  final Color text;
  final Color textMuted;
  final Color outline;
  final Color success;
  final Color heroBackground;
  final LinearGradient primaryGradient;
  final Color chipBackground;
  final Color orbTop;
  final Color orbBottom;
  final Color inputBar;

  static const milkshake = AppPalette(
    surfaceLow: Color(0xFFF1F4F6),
    surfaceCard: Color(0xFFFFFFFF),
    primaryDim: Color(0xFF3C3CCF),
    primaryContainer: Color(0xFFBABBFF),
    secondaryContainer: Color(0xFF68FAFF),
    tertiaryContainer: Color(0xFFC0ADFF),
    text: Color(0xFF2D3337),
    textMuted: Color(0xFF596063),
    outline: Color(0xFFE2E8F0),
    success: Color(0xFF1D8F61),
    heroBackground: Color(0xFFEFF2FF),
    primaryGradient: LinearGradient(colors: [Color(0xFF3C3CCF), Color(0xFF68FAFF)]),
    chipBackground: Color(0xFFE9ECFF),
    orbTop: Color(0x3357EBF0),
    orbBottom: Color(0x33C0ADFF),
    inputBar: Color(0xEAFEFEFE),
    surfaceElevated: Color(0xFFF8FAFB),
  );

  static const modernInk = AppPalette(
    surfaceLow: Color(0xFFF7F2E8),
    surfaceCard: Color(0xFFFFFFFF),
    primaryDim: Color(0xFFD32F2F),
    primaryContainer: Color(0xFFFFCDD2),
    secondaryContainer: Color(0xFF8D6E63),
    tertiaryContainer: Color(0xFF4E342E),
    text: Color(0xFF212121),
    textMuted: Color(0xFF757575),
    outline: Color(0xFFD7CCC8),
    success: Color(0xFF388E3C),
    heroBackground: Color(0xFFF1EAD7),
    primaryGradient: LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFF8D6E63)]),
    chipBackground: Color(0xFFFFE0B2),
    orbTop: Color(0x22D32F2F),
    orbBottom: Color(0x228D6E63),
    inputBar: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFCF9F3),
  );

  static const carbon = AppPalette(
    surfaceLow: Color(0xFF1F1F1F),
    surfaceCard: Color(0xFF2D2D2D),
    surfaceElevated: Color(0xFF353535),
    primaryDim: Color(0xFFF66E0D),
    primaryContainer: Color(0xFF4A2B15),
    secondaryContainer: Color(0xFF3A3A3A),
    tertiaryContainer: Color(0xFFF66E0D),
    text: Color(0xFFE3E3E3),
    textMuted: Color(0xFF929292),
    outline: Color(0xFF3F3F3F),
    success: Color(0xFF86B300),
    heroBackground: Color(0xFF1F1F1F),
    primaryGradient: LinearGradient(colors: [Color(0xFFF66E0D), Color(0xFF3A3A3A)]),
    chipBackground: Color(0xFF2A2A2A),
    orbTop: Color(0x22F66E0D),
    orbBottom: Color(0x223A3A3A),
    inputBar: Color(0xFF1A1A1A),
  );

  static const monkey8008 = AppPalette(
    surfaceLow: Color(0xFF333A45),
    surfaceCard: Color(0xFF3E4451),
    surfaceElevated: Color(0xFF4B5262),
    primaryDim: Color(0xFFF44C7F),
    primaryContainer: Color(0xFF3D2B3D),
    secondaryContainer: Color(0xFF00CED1),
    tertiaryContainer: Color(0xFF673AB7),
    text: Color(0xFFE5E9F0),
    textMuted: Color(0xFF9BABBC),
    outline: Color(0xFF4B5262),
    success: Color(0xFF98C379),
    heroBackground: Color(0xFF333A45),
    primaryGradient: LinearGradient(colors: [Color(0xFFF44C7F), Color(0xFF00CED1)]),
    chipBackground: Color(0xFF3E4451),
    orbTop: Color(0x22F44C7F),
    orbBottom: Color(0x2200CED1),
    inputBar: Color(0xFF2C313A),
  );

  static const dracula = AppPalette(
    surfaceLow: Color(0xFF282A36),
    surfaceCard: Color(0xFF44475A),
    surfaceElevated: Color(0xFF6272A4),
    primaryDim: Color(0xFFBD93F9),
    primaryContainer: Color(0xFF44475A),
    secondaryContainer: Color(0xFF50FA7B),
    tertiaryContainer: Color(0xFFFF79C6),
    text: Color(0xFFF8F8F2),
    textMuted: Color(0xFF6272A4),
    outline: Color(0xFF44475A),
    success: Color(0xFF50FA7B),
    heroBackground: Color(0xFF282A36),
    primaryGradient: LinearGradient(colors: [Color(0xFFBD93F9), Color(0xFFFF79C6)]),
    chipBackground: Color(0xFF44475A),
    orbTop: Color(0x22BD93F9),
    orbBottom: Color(0x22FF79C6),
    inputBar: Color(0xFF1E1F29),
  );

  static const deepSpace = AppPalette(
    surfaceLow: Color(0xFF000000), // OLED Black
    surfaceCard: Color(0xFF0C0E14),
    surfaceElevated: Color(0xFF12141C),
    primaryDim: Color(0xFFA855F7),
    primaryContainer: Color(0xFF1E1B4B),
    secondaryContainer: Color(0xFF083344),
    tertiaryContainer: Color(0xFF2E1065),
    text: Color(0xFFF8FAFC),
    textMuted: Color(0xFF64748B),
    outline: Color(0xFF1E293B),
    success: Color(0xFF10B981),
    heroBackground: Color(0xFF000000),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    chipBackground: Color(0xFF1e1b4b),
    orbTop: Color(0x227C3AED),
    orbBottom: Color(0x2206B6D4),
    inputBar: Color(0xED020617),
  );

  @override
  AppPalette copyWith({
    Color? surfaceLow,
    Color? surfaceCard,
    Color? primaryDim,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color? text,
    Color? textMuted,
    Color? outline,
    Color? success,
    Color? heroBackground,
    LinearGradient? primaryGradient,
    Color? chipBackground,
    Color? orbTop,
    Color? orbBottom,
    Color? inputBar,
    Color? surfaceElevated,
  }) {
    return AppPalette(
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      primaryDim: primaryDim ?? this.primaryDim,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      heroBackground: heroBackground ?? this.heroBackground,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      chipBackground: chipBackground ?? this.chipBackground,
      orbTop: orbTop ?? this.orbTop,
      orbBottom: orbBottom ?? this.orbBottom,
      inputBar: inputBar ?? this.inputBar,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiaryContainer:
          Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      success: Color.lerp(success, other.success, t)!,
      heroBackground: Color.lerp(heroBackground, other.heroBackground, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      orbTop: Color.lerp(orbTop, other.orbTop, t)!,
      orbBottom: Color.lerp(orbBottom, other.orbBottom, t)!,
      inputBar: Color.lerp(inputBar, other.inputBar, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

class AppColors {
  static const primary = Color(0xFFA855F7); // Vibrant Purple
  static const secondary = Color(0xFF06B6D4); // Electric Cyan
  static const tertiary = Color(0xFF7C3AED);
}

class AppTheme {
  static List<ThemeData> get themes => [
        _theme(brightness: Brightness.light, scaffold: AppPalette.milkshake.surfaceLow, palette: AppPalette.milkshake),
        _theme(brightness: Brightness.light, scaffold: AppPalette.modernInk.surfaceLow, palette: AppPalette.modernInk),
        _theme(brightness: Brightness.dark, scaffold: AppPalette.carbon.surfaceLow, palette: AppPalette.carbon),
        _theme(brightness: Brightness.dark, scaffold: AppPalette.monkey8008.surfaceLow, palette: AppPalette.monkey8008),
        _theme(brightness: Brightness.dark, scaffold: AppPalette.dracula.surfaceLow, palette: AppPalette.dracula),
        _theme(brightness: Brightness.dark, scaffold: AppPalette.deepSpace.surfaceLow, palette: AppPalette.deepSpace),
      ];

  static ThemeData get lightTheme => themes[0];
  static ThemeData get darkTheme => themes[5];

  static ThemeData _theme({
    required Brightness brightness,
    required Color scaffold,
    required AppPalette palette,
  }) {
    final isDark = brightness == Brightness.dark;
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: palette.text,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: palette.text,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.6,
        color: palette.text,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        color: palette.text,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: palette.textMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primaryDim,
        brightness: brightness,
        primary: palette.primaryDim,
        secondary: palette.secondaryContainer,
        tertiary: palette.tertiaryContainer,
        surface: scaffold,
      ),
      textTheme: textTheme,
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold.withValues(alpha: 0.92),
        foregroundColor: palette.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: isDark ? Colors.black.withValues(alpha: 0.2) : palette.text.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isDark ? BorderSide(color: palette.outline, width: 1) : BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surfaceCard,
        indicatorColor: palette.primaryDim.withValues(alpha: 0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: palette.primaryDim,
            );
          }
          return textTheme.labelSmall;
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isDark ? palette.primaryDim : palette.primaryContainer,
          foregroundColor: isDark ? Colors.white : palette.text,
          elevation: isDark ? 8 : 0,
          shadowColor: isDark ? palette.primaryDim.withValues(alpha: 0.4) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? palette.surfaceLow : Colors.white,
        labelStyle: TextStyle(color: palette.textMuted),
        hintStyle: TextStyle(color: palette.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: palette.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: palette.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: palette.primaryDim,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
