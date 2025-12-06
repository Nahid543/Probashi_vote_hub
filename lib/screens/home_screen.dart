import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../lang/app_language.dart';
import 'guide_screen.dart';
import 'documents_screen.dart';
import 'address_helper_screen.dart';
import 'about_screen.dart';
import 'key_dates_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppLanguage language;
  final VoidCallback onToggleLanguage;

  const HomeScreen({
    super.key,
    required this.language,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final horizontalPadding = isWide ? (size.width - 600) / 2 : 16.0;

    String t(String en, String bn) => tr(language, en, bn);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFF020617),
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFFF8FAFC),
            ),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF020617)
            : const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: SafeArea(
            child: Container(
              height: 64,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF020617)
                    : const Color(0xFFF8FAFC),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // App icon with gradient
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/app_icon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return const Icon(
                            Icons.how_to_vote_rounded,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // App title only
                  Expanded(
                    child: Text(
                      t('Probashi Vote Hub', 'প্রবাসী ভোট হাব'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Language toggle
                  _LanguageToggle(
                    language: language,
                    onToggle: onToggleLanguage,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          children: [
            _WelcomeCard(isDark: isDark, language: language),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 12),
              child: Text(
                t('Get started', 'শুরু করুন'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
            ),
            ..._buildNavigationCards(context, isDark, language),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavigationCards(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    final cards = [
      _NavCardData(
        icon: Icons.route_outlined,
        titleEn: 'Step-by-step Guide',
        titleBn: 'ধাপে ধাপে গাইড',
        subtitleEn: 'See the full postal voting journey in clear steps.',
        subtitleBn: 'পুরো পোস্টাল ভোট প্রক্রিয়াটি ধাপে ধাপে দেখুন।',
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuideScreen(language: language)),
        ),
      ),
      _NavCardData(
        icon: Icons.check_circle_outlined,
        titleEn: 'Documents Checklist',
        titleBn: 'ডকুমেন্টস চেকলিস্ট',
        subtitleEn:
            'Keep track of which documents are ready and which are left.',
        subtitleBn:
            'কোন ডকুমেন্ট তৈরি হয়েছে আর কোনটি বাকি আছে তা ট্র্যাক করুন।',
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DocumentsScreen(language: language),
          ),
        ),
      ),
      _NavCardData(
        icon: Icons.location_on_outlined,
        titleEn: 'Address Helper',
        titleBn: 'অ্যাড্রেস হেল্পার',
        subtitleEn: 'Write your overseas address in a clear format.',
        subtitleBn:
            'বিদেশের ঠিকানাটি পরিষ্কার ও সঠিক ফরম্যাটে লিখতে সাহায্য করবে।',
        gradient: const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddressHelperScreen(language: language),
          ),
        ),
      ),
      _NavCardData(
        icon: Icons.event_note_outlined,
        titleEn: 'Key Dates & Registration',
        titleBn: 'মূল তারিখ ও নিবন্ধন সময়',
        subtitleEn: "Note important dates so you don't miss deadlines.",
        subtitleBn:
            "গুরুত্বপূর্ণ তারিখ নোট রাখুন, যেন কোনো ডেডলাইন মিস না হয়।",
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KeyDatesScreen(language: language)),
        ),
      ),
      _NavCardData(
        icon: Icons.info_outline_rounded,
        titleEn: 'About & Disclaimer',
        titleBn: 'অ্যাপ তথ্য ও ডিসক্লেমার',
        subtitleEn: 'Learn how this helper app works and its limitations.',
        subtitleBn: 'এই সহায়ক অ্যাপ কীভাবে কাজ করে এবং এর সীমাবদ্ধতা জানুন।',
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AboutScreen(language: language)),
        ),
      ),
    ];

    return cards.asMap().entries.map((entry) {
      return Padding(
        padding: EdgeInsets.only(bottom: entry.key < cards.length - 1 ? 12 : 0),
        child: _NavigationCard(
          language: language,
          data: entry.value,
          isDark: isDark,
        ),
      );
    }).toList();
  }
}

// Data model for navigation cards
class _NavCardData {
  final IconData icon;
  final String titleEn;
  final String titleBn;
  final String subtitleEn;
  final String subtitleBn;
  final Gradient gradient;
  final VoidCallback onTap;

  _NavCardData({
    required this.icon,
    required this.titleEn,
    required this.titleBn,
    required this.subtitleEn,
    required this.subtitleBn,
    required this.gradient,
    required this.onTap,
  });
}

// Welcome card with modern, compact design
class _WelcomeCard extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;

  const _WelcomeCard({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('Welcome 👋', 'স্বাগতম 👋'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t(
              'A practical helper for Bangladeshi citizens living abroad to understand and prepare for postal voting using the official government systems.',
              'বিদেশে বসবাসকারী বাংলাদেশি নাগরিকদের জন্য একটি ব্যবহারিক সহায়ক অ্যাপ, যাতে তারা সরকারি পদ্ধতি ব্যবহার করে পোস্টাল ভোট প্রক্রিয়াটি সহজে বুঝে প্রস্তুতি নিতে পারেন।',
            ),
            style: TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : const Color(0xFF64748B),
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 14),
          // Disclaimer banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.amber.withOpacity(0.08)
                  : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.amber.shade200,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
                  size: 19,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t(
                      'This is NOT an official Election Commission app. It does not collect or submit any votes or applications. Always follow the latest instructions on the official Election Commission or embassy website.',
                      'এটি নির্বাচন কমিশনের বা কোনো সরকারি অ্যাপ নয়। এটি কোনো ভোট বা আবেদন সংগ্রহ বা জমা করে না। সব সময় নির্বাচন কমিশন বা দূতাবাসের অফিসিয়াল ওয়েবসাইটে দেওয়া সর্বশেষ নির্দেশনা অনুসরণ করুন।',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark
                          ? Colors.amber.shade200
                          : Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modern navigation card with optimized design
class _NavigationCard extends StatelessWidget {
  final AppLanguage language;
  final _NavCardData data;
  final bool isDark;

  const _NavigationCard({
    required this.language,
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            data.onTap();
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: data.gradient.colors.first.withOpacity(0.08),
          highlightColor: data.gradient.colors.first.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: data.gradient,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: data.gradient.colors.first.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(data.titleEn, data.titleBn),
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t(data.subtitleEn, data.subtitleBn),
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : const Color(0xFF64748B),
                          letterSpacing: 0.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Arrow icon
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Polished language toggle with smooth animation
class _LanguageToggle extends StatelessWidget {
  final AppLanguage language;
  final VoidCallback onToggle;
  final bool isDark;

  const _LanguageToggle({
    required this.language,
    required this.onToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isBangla = language == AppLanguage.bn;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      child: Container(
        padding: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFE5E7EB),
        ),
        child: SizedBox(
          width: 88,
          height: 34,
          child: Stack(
            children: [
              // Animated highlight
              AnimatedAlign(
                alignment: isBangla
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: 42,
                  height: 27,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LangLabel(text: 'EN', isActive: !isBangla),
                  _LangLabel(text: 'বাংলা', isActive: isBangla),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangLabel extends StatelessWidget {
  final String text;
  final bool isActive;

  const _LangLabel({required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: isActive ? Colors.white : Colors.black.withOpacity(0.5),
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
