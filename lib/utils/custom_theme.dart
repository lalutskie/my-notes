import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 📏 Device Size Enum
enum DeviceSize { mobile, tablet, desktop }

/// 🌐 Helper to detect device type
DeviceSize getDeviceSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return DeviceSize.mobile;
  if (width < 1024) return DeviceSize.tablet;
  return DeviceSize.desktop;
}

/// 🎨 Color Extension for ThemeData
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color alternate;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color primaryBackground;
  final Color secondaryBackground;
  final Color accent1;
  final Color accent2;
  final Color accent3;
  final Color accent4;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.alternate,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.accent4,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? alternate,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? accent1,
    Color? accent2,
    Color? accent3,
    Color? accent4,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      alternate: alternate ?? this.alternate,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      accent4: accent4 ?? this.accent4,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return this;
  }

  /// 🌞 Light Mode Colors
  static const light = AppColors(
    primary: Color(0xFF556B2F),
    secondary: Color(0xFFC6D870),
    tertiary: Color(0xFF8FA31E),
    alternate: Color(0xFFEFF5D2),
    primaryText: Color(0xFF101213),
    secondaryText: Color(0xFFFFFFFF),
    tertiaryText: Color(0xFF57564F),
    primaryBackground: Color(0xFFF0F0F0),
    secondaryBackground: Colors.white,
    accent1: Color(0x4C4B39EF),
    accent2: Color(0x4D39D2C0),
    accent3: Color(0x4DEE8B60),
    accent4: Color(0xCCFFFFFF),
    success: Color(0xFF249689),
    warning: Color(0xFFF0C528),
    error: Color(0xFFE21C3D),
    info: Color(0xFF1C4494),
  );

  /// 🌚 Dark Mode Colors
  static const dark = AppColors(
    primary: Color(0xFF9A89FF),
    secondary: Color(0xFF5FE0D2),
    tertiary: Color(0xFFFFA580),
    alternate: Color(0xFF2C2C2C),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFFB0B0B0),
    tertiaryText: Color(0xFFFFFFFF),
    primaryBackground: Color(0xFF121212),
    secondaryBackground: Color(0xFF1E1E1E),
    accent1: Color(0x664B39EF),
    accent2: Color(0x6639D2C0),
    accent3: Color(0x66EE8B60),
    accent4: Color(0x99FFFFFF),
    success: Color(0xFF27CFA5),
    warning: Color(0xFFE6B91F),
    error: Color(0xFFFF5C77),
    info: Color(0xFF3D6EFF),
  );
}

/// 🖋 Typography Extension
class AppTypography {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  const AppTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,

  });

  /// 📱 Mobile Sizes
  factory AppTypography.responsive(AppColors colors, DeviceSize size) {
  // Define base font sizes depending on device
  late double displayLargeSize;
  late double displayMediumSize;
  late double displaySmallSize;
  late double headlineLargeSize;
  late double headlineMediumSize;
  late double headlineSmallSize;
  late double bodyLargeSize;
  late double bodyMediumSize;
  late double bodySmallSize;

  switch (size) {
    case DeviceSize.mobile:
      displayLargeSize = 34;
      displayMediumSize = 30;
      displaySmallSize = 26;
      headlineLargeSize = 24;
      headlineMediumSize = 20;
      headlineSmallSize = 18;
      bodyLargeSize = 16;
      bodyMediumSize = 14;
      bodySmallSize = 12;
      break;

    case DeviceSize.tablet:
      displayLargeSize = 38;
      displayMediumSize = 34;
      displaySmallSize = 30;
      headlineLargeSize = 26;
      headlineMediumSize = 24;
      headlineSmallSize = 22;
      bodyLargeSize = 18;
      bodyMediumSize = 16;
      bodySmallSize = 14;
      
      break;

    case DeviceSize.desktop:
      displayLargeSize = 45;
      displayMediumSize = 40;
      displaySmallSize = 35;
      headlineLargeSize = 30;
      headlineMediumSize = 26;
      headlineSmallSize = 22;
      bodyLargeSize = 20;
      bodyMediumSize = 18;
      bodySmallSize = 16;
      break;
  }

  return AppTypography(
    displayLarge: GoogleFonts.poppins(
      fontSize: displayLargeSize,
      color: colors.primaryText,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: displayMediumSize,
      color: colors.primaryText,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: displaySmallSize,
      color: colors.primaryText,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: headlineLargeSize,
      color: colors.primaryText,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: headlineMediumSize,
      color: colors.primaryText,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: headlineSmallSize,
      color: colors.primaryText,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: bodyLargeSize,
      color: colors.primaryText,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: bodyMediumSize,
      color: colors.secondaryText,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: bodySmallSize,
      fontWeight: FontWeight.normal,
      color: colors.secondaryText,
    ),
  );
}

}

/// 🎨 Theme Provider (Light & Dark)
class CustomTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    extensions: const [AppColors.light],
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: AppColors.light.primaryBackground
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    extensions: const [AppColors.dark],
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: AppColors.dark.primaryBackground
  );

  /// 🖌 Get colors easily
  static AppColors colors(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? AppColors.light;

  /// 🖋 Get typography based on device
  static AppTypography typography(BuildContext context) {
    final size = getDeviceSize(context);
    final colors = CustomTheme.colors(context);

    return AppTypography.responsive(colors, size);
  }
}
