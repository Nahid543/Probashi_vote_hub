import 'package:flutter/material.dart';
import '../lang/app_language.dart';

class OnboardingScreen extends StatefulWidget {
  final AppLanguage initialLanguage;
  final ValueChanged<AppLanguage> onLanguageSelected;
  final VoidCallback onFinished;

  const OnboardingScreen({
    super.key,
    required this.initialLanguage,
    required this.onLanguageSelected,
    required this.onFinished,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AppLanguage _lang;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _lang = widget.initialLanguage;
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    setState(() {
      _currentPage = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectLanguage(AppLanguage lang) {
    setState(() {
      _lang = lang;
    });
    widget.onLanguageSelected(lang);
  }

  Widget _buildLanguageCard(AppLanguage lang, String flag, String name) {
    final bool isSelected = _lang == lang;

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectLanguage(lang),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF14B8A6), // teal-500
                      Color(0xFF0D9488), // teal-600
                    ],
                  )
                : null,
            color: isSelected ? null : const Color(0xFF0F172A),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : const Color(0xFF1E293B).withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '✓',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final bool active = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: active
                ? const Color(0xFF14B8A6)
                : const Color(0xFF1E293B).withOpacity(0.4),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = _lang;
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF134E4A), // teal-900
              Color(0xFF115E59), // teal-800
              Color(0xFF0F766E), // teal-700
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth =
                      constraints.maxWidth > 640 ? 640 : constraints.maxWidth;

                  return SizedBox(
                    width: maxWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32 : 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          
                          // App header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF14B8A6)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/app_icon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Probashi Vote Hub',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),

                          // Page content
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: const ClampingScrollPhysics(),
                              onPageChanged: (value) {
                                setState(() {
                                  _currentPage = value;
                                });
                              },
                              children: [
                                // PAGE 0 – Language Selection
                                _buildLanguagePage(lang, isTablet),
                                
                                // PAGE 1 – Features Overview
                                _buildFeaturesPage(lang, isTablet),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          _buildDots(),
                          const SizedBox(height: 24),

                          // Navigation buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: widget.onFinished,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  tr(lang, 'Skip', 'এড়িয়ে যান'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 32 : 24,
                                    vertical: 14,
                                  ),
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: const Color(0xFF14B8A6)
                                      .withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  if (_currentPage < 1) {
                                    _goToPage(_currentPage + 1);
                                  } else {
                                    widget.onFinished();
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentPage < 1
                                          ? tr(lang, 'Next', 'পরবর্তী')
                                          : tr(lang, 'Get Started', 'শুরু করুন'),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguagePage(AppLanguage lang, bool isTablet) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(
              lang,
              'Choose your language',
              'আপনার ভাষা বেছে নিন',
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 32 : 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tr(
              lang,
              'You can change this anytime from settings',
              'সেটিংস থেকে যেকোনো সময় পরিবর্তন করতে পারবেন',
            ),
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: isTablet ? 16 : 15,
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              _buildLanguageCard(
                AppLanguage.en,
                '🇬🇧',
                'English',
              ),
              const SizedBox(width: 16),
              _buildLanguageCard(
                AppLanguage.bn,
                '🇧🇩',
                'বাংলা',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPage(AppLanguage lang, bool isTablet) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(
              lang,
              'What you can do',
              'যা করতে পারবেন',
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 32 : 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildFeatureItem(
            lang,
            Icons.checklist_rounded,
            'Step-by-step postal voting guide',
            'পোস্টাল ভোটের স্টেপ-বাই-স্টেপ গাইড',
          ),
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            lang,
            Icons.task_alt_rounded,
            'Private document checklist',
            'প্রাইভেট ডকুমেন্ট চেকলিস্ট',
          ),
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            lang,
            Icons.location_on_rounded,
            'Overseas address helper',
            'বিদেশি ঠিকানা সহায়ক',
          ),
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            lang,
            Icons.calendar_today_rounded,
            'Key dates and official links',
            'গুরুত্বপূর্ণ তারিখ ও অফিসিয়াল লিংক',
          ),
          
          const SizedBox(height: 28),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: const Color(0xFF5EEAD4),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tr(
                      lang,
                      'This app is designed to assist users. For final confirmation, please refer to the “Postal Vote BD” app and follow the Election Commission guidance.',
                      'এই অ্যাপটি ব্যবহারকারীদের সহায়তার জন্য তৈরি। চূড়ান্ত নিশ্চিতকরণের জন্য “Postal Vote BD” অ্যাপ ও নির্বাচন কমিশনের নির্দেশনাগুলি অনুসরণ করুন।',
                    ),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.5,
                      letterSpacing: 0.2,
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

  Widget _buildFeatureItem(
    AppLanguage lang,
    IconData icon,
    String enText,
    String bnText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5EEAD4),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              tr(lang, enText, bnText),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
