import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static const Color brandPrimary = Color(0xFF4285F4);
  static const Color brandSecondary = Color(0xFFFCDE5B);

  static const Color stateInfo = Color(0xFF064C5B);
  static const Color stateSuccess = Color(0xFF0A9F19);
  static const Color stateWarning = Color(0xFF806900);
  static const Color stateError = Color(0xFFDF0C0C);

  static const Color black1 = Color(0xFF000000);
  static const Color black2 = Color(0xFF1D1D1D);
  static const Color black3 = Color(0xFF282828);
  static const Color white = Color(0xFFFFFFFF);

  static const Color gray1 = Color(0xFF333333);
  static const Color gray2 = Color(0xFF4F4F4F);
  static const Color gray3 = Color(0xFF828282);
  static const Color gray4 = Color(0xFFBDBDBD);
  static const Color gray5 = Color(0xFFE0E0E0);

  static const Color gradientStart = Color(0xFF0CC0DF);
  static const Color gradientEnd = Color(0xFF4285F4);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: brandPrimary, // #0CC0DF
      surfaceTint: brandPrimary,
      onPrimary: white,
      primaryContainer: Color(0xFFB8F3FF),
      onPrimaryContainer: stateInfo,
      secondary: brandSecondary,
      onSecondary: black1,
      secondaryContainer: Color(0xFFFFF4C4),
      onSecondaryContainer: stateWarning,
      tertiary: stateInfo,
      onTertiary: white,
      tertiaryContainer: Color(0xFFB8E5F0),
      onTertiaryContainer: stateInfo,
      error: stateError,
      onError: white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF8C0000),
      surface: white,
      onSurface: black1,
      onSurfaceVariant: gray2,
      outline: gray3,
      outlineVariant: gray5,
      shadow: black1,
      scrim: black1,
      inverseSurface: black2,
      inversePrimary: Color(0xFF7DE3FF),
      primaryFixed: Color(0xFFB8F3FF),
      onPrimaryFixed: stateInfo,
      primaryFixedDim: Color(0xFF7DE3FF),
      onPrimaryFixedVariant: Color(0xFF087A8F),
      secondaryFixed: Color(0xFFFFF4C4),
      onSecondaryFixed: stateWarning,
      secondaryFixedDim: Color(0xFFFFEB9A),
      onSecondaryFixedVariant: Color(0xFF5C4A00),
      tertiaryFixed: Color(0xFFB8E5F0),
      onTertiaryFixed: Color(0xFF002731),
      tertiaryFixedDim: Color(0xFF85D0E0),
      onTertiaryFixedVariant: stateInfo,
      surfaceDim: gray5,
      surfaceBright: white,
      surfaceContainerLowest: white,
      surfaceContainerLow: Color(0xFFF5F5F5),
      surfaceContainer: gray5,
      surfaceContainerHigh: Color(0xFFD9D9D9),
      surfaceContainerHighest: gray4,
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7DE3FF),
      surfaceTint: Color(0xFF7DE3FF),
      onPrimary: stateInfo,
      primaryContainer: Color(0xFF087A8F),
      onPrimaryContainer: Color(0xFFB8F3FF),
      secondary: Color(0xFFFFEB9A),
      onSecondary: stateWarning,
      secondaryContainer: Color(0xFF5C4A00),
      onSecondaryContainer: Color(0xFFFFF4C4),
      tertiary: Color(0xFF85D0E0),
      onTertiary: Color(0xFF002731),
      tertiaryContainer: stateInfo,
      onTertiaryContainer: Color(0xFFB8E5F0),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: black2,
      onSurface: white,
      onSurfaceVariant: gray4,
      outline: gray3,
      outlineVariant: gray2,
      shadow: black1,
      scrim: black1,
      inverseSurface: white,
      inversePrimary: brandPrimary,
      primaryFixed: Color(0xFFB8F3FF),
      onPrimaryFixed: stateInfo,
      primaryFixedDim: Color(0xFF7DE3FF),
      onPrimaryFixedVariant: Color(0xFF087A8F),
      secondaryFixed: Color(0xFFFFF4C4),
      onSecondaryFixed: stateWarning,
      secondaryFixedDim: Color(0xFFFFEB9A),
      onSecondaryFixedVariant: Color(0xFF5C4A00),
      tertiaryFixed: Color(0xFFB8E5F0),
      onTertiaryFixed: Color(0xFF002731),
      tertiaryFixedDim: Color(0xFF85D0E0),
      onTertiaryFixedVariant: stateInfo,
      surfaceDim: black2,
      surfaceBright: gray1,
      surfaceContainerLowest: black1,
      surfaceContainerLow: black2,
      surfaceContainer: black3,
      surfaceContainerHigh: Color(0xFF3D3D3D),
      surfaceContainerHighest: gray2,
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  static LinearGradient createBrandGradient({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [gradientStart, gradientEnd],
    );
  }

  static LinearGradient createLightGradient({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    double opacity = 0.1,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        gradientStart.withValues(alpha: opacity),
        white,
      ],
    );
  }

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
