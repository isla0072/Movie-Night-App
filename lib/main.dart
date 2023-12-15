import 'package:flutter/material.dart';
import 'pages/welcome_screen.dart';
import 'pages/share_screen.dart';
import 'pages/enter_screen.dart';
import 'pages/selection_screen.dart';

class MyColors {
  static const Color primaryColor = Color(0xFFFFDB15);
  static const Color secondaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFE1E1E1);
  static const Color backgroundColor = Color(0xFF3B3F46);
  static const Color textColor = Color(0xFFFFFFFF);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ColorScheme myColorScheme = ColorScheme.light(
      primary: MyColors.primaryColor,
      onPrimary: MyColors.secondaryColor,
      secondary: MyColors.secondaryColor,
      onSecondary: MyColors.textColor,
      background: MyColors.backgroundColor,
      onBackground: MyColors.textColor,
      error: Colors.red,
      onError: MyColors.primaryColor,
      surface: MyColors.secondaryColor,
      onSurface: MyColors.textColor,
      brightness: Brightness.dark,
    );

    const TextTheme myTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 32.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18.0,
      ),
    );

    return MaterialApp(
      title: 'Movie Night App',
      theme: ThemeData(
        colorScheme: myColorScheme,
        textTheme: myTextTheme,
      ),
      initialRoute: '/',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/shareCode':
        return MaterialPageRoute(builder: (_) => const ShareScreen());
      case '/enterCode':
        return MaterialPageRoute(builder: (_) => const EnterScreen());
      case '/movieSelection':
        return MaterialPageRoute(builder: (_) => const SelectionScreen());
      default:
        return null;
    }
  }
}
