import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281794730),
      surfaceTint: Color(4284498138),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284103124),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4284503446),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291477247),
      onSecondaryContainer: Color(4281805931),
      tertiary: Color(4284809315),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288159636),
      onTertiaryContainer: Color(4294967039),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294834431),
      onBackground: Color(4280031779),
      surface: Color(4294834431),
      onSurface: Color(4280031779),
      surfaceVariant: Color(4293320692),
      onSurfaceVariant: Color(4282926421),
      outline: Color(4286150022),
      outlineVariant: Color(4291413207),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413433),
      inverseOnSurface: Color(4294242044),
      inversePrimary: Color(4291477247),
      primaryFixed: Color(4293320447),
      onPrimaryFixed: Color(4280025186),
      primaryFixedDim: Color(4291477247),
      onPrimaryFixedVariant: Color(4282916802),
      secondaryFixed: Color(4293320447),
      onSecondaryFixed: Color(4280028751),
      secondaryFixedDim: Color(4291477247),
      onSecondaryFixedVariant: Color(4282924413),
      tertiaryFixed: Color(4294957045),
      onTertiaryFixed: Color(4281860151),
      tertiaryFixedDim: Color(4294945778),
      onTertiaryFixedVariant: Color(4286644352),
      surfaceDim: Color(4292729061),
      surfaceBright: Color(4294834431),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439422),
      surfaceContainer: Color(4294044921),
      surfaceContainerHigh: Color(4293650163),
      surfaceContainerHighest: Color(4293320941),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281794730),
      surfaceTint: Color(4284498138),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284103124),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282661241),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286016430),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284809315),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288159636),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294834431),
      onBackground: Color(4280031779),
      surface: Color(4294834431),
      onSurface: Color(4280031779),
      surfaceVariant: Color(4293320692),
      onSurfaceVariant: Color(4282663248),
      outline: Color(4284570990),
      outlineVariant: Color(4286412938),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413433),
      inverseOnSurface: Color(4294242044),
      inversePrimary: Color(4291477247),
      primaryFixed: Color(4286012146),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284366296),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286016430),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284371860),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4290396851),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4288423064),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729061),
      surfaceBright: Color(4294834431),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439422),
      surfaceContainer: Color(4294044921),
      surfaceContainerHigh: Color(4293650163),
      surfaceContainerHighest: Color(4293320941),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4280483956),
      surfaceTint: Color(4284498138),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282652606),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280489558),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282661241),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282581058),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286251129),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294834431),
      onBackground: Color(4280031779),
      surface: Color(4294834431),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4293320692),
      onSurfaceVariant: Color(4280623664),
      outline: Color(4282663248),
      outlineVariant: Color(4282663248),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413433),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4293913087),
      primaryFixed: Color(4282652606),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281139344),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282661241),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281213537),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286251129),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283760724),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729061),
      surfaceBright: Color(4294834431),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439422),
      surfaceContainer: Color(4294044921),
      surfaceContainerHigh: Color(4293650163),
      surfaceContainerHighest: Color(4293320941),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4291477247),
      surfaceTint: Color(4291477247),
      onPrimary: Color(4281401498),
      primaryContainer: Color(4282520509),
      onPrimaryContainer: Color(4292530687),
      secondary: Color(4291477247),
      onSecondary: Color(4281476709),
      secondaryContainer: Color(4282332275),
      onSecondaryContainer: Color(4292201215),
      tertiary: Color(4294945778),
      onTertiary: Color(4284153946),
      tertiaryContainer: Color(4286054518),
      onTertiaryContainer: Color(4294952691),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279505435),
      onBackground: Color(4293320941),
      surface: Color(4279505435),
      onSurface: Color(4293320941),
      surfaceVariant: Color(4282926421),
      onSurfaceVariant: Color(4291413207),
      outline: Color(4287860384),
      outlineVariant: Color(4282926421),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293320941),
      inverseOnSurface: Color(4281413433),
      inversePrimary: Color(4284498138),
      primaryFixed: Color(4293320447),
      onPrimaryFixed: Color(4280025186),
      primaryFixedDim: Color(4291477247),
      onPrimaryFixedVariant: Color(4282916802),
      secondaryFixed: Color(4293320447),
      onSecondaryFixed: Color(4280028751),
      secondaryFixedDim: Color(4291477247),
      onSecondaryFixedVariant: Color(4282924413),
      tertiaryFixed: Color(4294957045),
      onTertiaryFixed: Color(4281860151),
      tertiaryFixedDim: Color(4294945778),
      onTertiaryFixedVariant: Color(4286644352),
      surfaceDim: Color(4279505435),
      surfaceBright: Color(4282005570),
      surfaceContainerLowest: Color(4279176470),
      surfaceContainerLow: Color(4280031779),
      surfaceContainer: Color(4280294952),
      surfaceContainerHigh: Color(4281018674),
      surfaceContainerHighest: Color(4281742141),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4291740671),
      surfaceTint: Color(4291477247),
      onPrimary: Color(4279697492),
      primaryContainer: Color(4287921663),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291740671),
      onSecondary: Color(4279699018),
      secondaryContainer: Color(4287858893),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294947570),
      onTertiary: Color(4281270318),
      tertiaryContainer: Color(4292632786),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279505435),
      onBackground: Color(4293320941),
      surface: Color(4279505435),
      onSurface: Color(4294900223),
      surfaceVariant: Color(4282926421),
      onSurfaceVariant: Color(4291741915),
      outline: Color(4289044659),
      outlineVariant: Color(4286939538),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293320941),
      inverseOnSurface: Color(4281018674),
      inversePrimary: Color(4282982851),
      primaryFixed: Color(4293320447),
      onPrimaryFixed: Color(4279304262),
      primaryFixedDim: Color(4291477247),
      onPrimaryFixedVariant: Color(4281794730),
      secondaryFixed: Color(4293320447),
      onSecondaryFixed: Color(4279304261),
      secondaryFixedDim: Color(4291477247),
      onSecondaryFixedVariant: Color(4281805931),
      tertiaryFixed: Color(4294957045),
      onTertiaryFixed: Color(4280746022),
      tertiaryFixedDim: Color(4294945778),
      onTertiaryFixedVariant: Color(4284809316),
      surfaceDim: Color(4279505435),
      surfaceBright: Color(4282005570),
      surfaceContainerLowest: Color(4279176470),
      surfaceContainerLow: Color(4280031779),
      surfaceContainer: Color(4280294952),
      surfaceContainerHigh: Color(4281018674),
      surfaceContainerHighest: Color(4281742141),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294900223),
      surfaceTint: Color(4291477247),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4291740671),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294900223),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291740671),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965754),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294947570),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279505435),
      onBackground: Color(4293320941),
      surface: Color(4279505435),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282926421),
      onSurfaceVariant: Color(4294900223),
      outline: Color(4291741915),
      outlineVariant: Color(4291741915),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293320941),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4280942729),
      primaryFixed: Color(4293583871),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4291740671),
      onPrimaryFixedVariant: Color(4279697492),
      secondaryFixed: Color(4293583871),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291740671),
      onSecondaryFixedVariant: Color(4279699018),
      tertiaryFixed: Color(4294958581),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294947570),
      onTertiaryFixedVariant: Color(4281270318),
      surfaceDim: Color(4279505435),
      surfaceBright: Color(4282005570),
      surfaceContainerLowest: Color(4279176470),
      surfaceContainerLow: Color(4280031779),
      surfaceContainer: Color(4280294952),
      surfaceContainerHigh: Color(4281018674),
      surfaceContainerHighest: Color(4281742141),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) {
    InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
      labelStyle: TextStyle(fontSize: 12.0, color: Colors.blueGrey));

    ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimaryContainer,
        backgroundColor: colorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        )
      )
    );
    return ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
            dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: inputDecorationTheme),
            inputDecorationTheme: inputDecorationTheme,
            elevatedButtonTheme: elevatedButtonThemeData,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
          fontSizeDelta: 8.0,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );
  }

  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
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
