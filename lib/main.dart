import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lang/app_language.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const ProbashiVoteHubApp());
}

class ProbashiVoteHubApp extends StatefulWidget {
  const ProbashiVoteHubApp({super.key});

  @override
  State<ProbashiVoteHubApp> createState() => _ProbashiVoteHubAppState();
}

class _ProbashiVoteHubAppState extends State<ProbashiVoteHubApp> {
  AppLanguage _language = AppLanguage.en;

  bool _showSplash = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _startSplashTimer();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Language
    final langCode = prefs.getString('selected_language');
    if (langCode == 'bn') {
      _language = AppLanguage.bn;
    } else if (langCode == 'en') {
      _language = AppLanguage.en;
    }

    // Onboarding flag
    final onboardingSeen = prefs.getBool('onboarding_seen_v1') ?? false;

    setState(() {
      _showOnboarding = !onboardingSeen; // if seen -> false
    });
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  Future<void> _setLanguage(AppLanguage lang) async {
    setState(() {
      _language = lang;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'selected_language',
      lang == AppLanguage.en ? 'en' : 'bn',
    );
  }

  Future<void> _toggleLanguage() async {
    setState(() {
      _language =
          _language == AppLanguage.en ? AppLanguage.bn : AppLanguage.en;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'selected_language',
      _language == AppLanguage.en ? 'en' : 'bn',
    );
  }

  Future<void> _finishOnboarding() async {
    setState(() {
      _showOnboarding = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen_v1', true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      brightness: Brightness.light,
    );

    Widget home;
    if (_showSplash) {
      home = const SplashScreen();
    } else if (_showOnboarding) {
      home = OnboardingScreen(
        initialLanguage: _language,
        onLanguageSelected: _setLanguage,
        onFinished: _finishOnboarding,
      );
    } else {
      home = HomeScreen(
        language: _language,
        onToggleLanguage: _toggleLanguage,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Probashi Vote Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: home,
    );
  }
}
