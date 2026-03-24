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
    required this.chipBackground,
    required this.orbTop,
    required this.orbBottom,
    required this.inputBar,
  });

  final Color surfaceLow;
  final Color surfaceCard;
  final Color primaryDim;
  final Color primaryContainer;
  final Color secondaryContainer;
  final Color tertiaryContainer;
  final Color text;
  final Color textMuted;
  final Color outline;
  final Color success;
  final Color heroBackground;
  final Color chipBackground;
  final Color orbTop;
  final Color orbBottom;
  final Color inputBar;

  static const light = AppPalette(
    surfaceLow: Color(0xFFF1F4F6),
    surfaceCard: Color(0xFFFFFFFF),
    primaryDim: Color(0xFF3C3CCF),
    primaryContainer: Color(0xFFBABBFF),
    secondaryContainer: Color(0xFF68FAFF),
    tertiaryContainer: Color(0xFFC0ADFF),
    text: Color(0xFF2D3337),
    textMuted: Color(0xFF596063),
    outline: Color(0xFFACB3B7),
    success: Color(0xFF1D8F61),
    heroBackground: Color(0xFFEFF2FF),
    chipBackground: Color(0xFFE9ECFF),
    orbTop: Color(0x3357EBF0),
    orbBottom: Color(0x33C0ADFF),
    inputBar: Color(0xEAFEFEFE),
  );

  static const dark = AppPalette(
    surfaceLow: Color(0xFF181E2B),
    surfaceCard: Color(0xFF101522),
    primaryDim: Color(0xFF7078FF),
    primaryContainer: Color(0xFF30348B),
    secondaryContainer: Color(0xFF11474A),
    tertiaryContainer: Color(0xFF3B2B6D),
    text: Color(0xFFF1F4FA),
    textMuted: Color(0xFF9DA8BC),
    outline: Color(0xFF455066),
    success: Color(0xFF55C692),
    heroBackground: Color(0xFF151A2B),
    chipBackground: Color(0xFF1B2140),
    orbTop: Color(0x33494ADB),
    orbBottom: Color(0x333B2B6D),
    inputBar: Color(0xED0B1020),
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
    Color? chipBackground,
    Color? orbTop,
    Color? orbBottom,
    Color? inputBar,
  }) {
    return AppPalette(
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      primaryDim: primaryDim ?? this.primaryDim,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      heroBackground: heroBackground ?? this.heroBackground,
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
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      orbTop: Color.lerp(orbTop, other.orbTop, t)!,
      orbBottom: Color.lerp(orbBottom, other.orbBottom, t)!,
      inputBar: Color.lerp(inputBar, other.inputBar, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

class AppColors {
  static const primary = Color(0xFF494ADB);
  static const secondary = Color(0xFF006A6D);
  static const tertiary = Color(0xFF664ABE);
}

class AppTheme {
  static ThemeData get lightTheme => _theme(
        brightness: Brightness.light,
        scaffold: const Color(0xFFF7F9FB),
        palette: AppPalette.light,
      );

  static ThemeData get darkTheme => _theme(
        brightness: Brightness.dark,
        scaffold: const Color(0xFF070B14),
        palette: AppPalette.dark,
      );

  static ThemeData _theme({
    required Brightness brightness,
    required Color scaffold,
    required AppPalette palette,
  }) {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: palette.text,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: palette.text,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        height: 1.6,
        color: palette.text,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        height: 1.5,
        color: palette.text,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      labelMedium: GoogleFonts.manrope(
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
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surfaceCard,
        indicatorColor: AppColors.primary.withValues(alpha: 0.14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primaryContainer,
          foregroundColor: palette.text,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceLow,
        labelStyle: TextStyle(color: palette.textMuted),
        hintStyle: TextStyle(color: palette.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}
