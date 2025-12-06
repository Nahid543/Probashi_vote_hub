import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/app_language.dart';

class DocumentsScreen extends StatefulWidget {
  final AppLanguage language;

  const DocumentsScreen({super.key, required this.language});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  static const _prefsKey = 'documents_checklist_states_v2';

  // Updated list based on Election Commission & mission guidance:
  // NID is the anchor for eligibility; scanned passport + visa / residence
  // permit are required in many notices, along with clear overseas address.
  // A live face photo and contact details are also used in verification.
  static const List<_DocumentItemData> _itemsData = [
    _DocumentItemData(
      id: 'nid',
      titleEn: 'Bangladeshi National ID (NID)',
      titleBn: 'বাংলাদেশি জাতীয় পরিচয়পত্র (এনআইডি)',
      descriptionEn:
          'Keep your NID card and number ready. The app checks your voter record in the National ID database, so the name and birth date must match exactly.',
      descriptionBn:
          'আপনার এনআইডি কার্ড এবং নম্বর কাছে রাখুন। অ্যাপটি জাতীয় পরিচয়পত্র ডেটাবেস থেকে আপনার ভোটারের তথ্য মিলিয়ে দেখে, তাই নাম ও জন্মতারিখ অবশ্যই হুবহু মিলতে হবে।',
      icon: Icons.badge_outlined,
      colorValue: 0xFF6366F1,
    ),
    _DocumentItemData(
      id: 'passport',
      titleEn: 'Valid Bangladeshi passport',
      titleBn: 'বৈধ বাংলাদেশি পাসপোর্ট',
      descriptionEn:
          'A clear photo/scan of the passport information page (with your photo). The passport should be valid on the day you register.',
      descriptionBn:
          'পাসপোর্টের তথ্যপাতার (যেখানে ছবি আছে) পরিষ্কার ছবি/স্ক্যান। নিবন্ধনের দিন পাসপোর্টটি অবশ্যই বৈধ থাকতে হবে।',
      icon: Icons.book_outlined,
      colorValue: 0xFFEC4899,
    ),
    _DocumentItemData(
      id: 'visa',
      titleEn: 'Visa or residence permit',
      titleBn: 'ভিসা বা রেসিডেন্স পারমিট',
      descriptionEn:
          'Scan or photo of your visa sticker, work permit, iqama, BRP, residence card or other proof that you are legally staying in the country where you live.',
      descriptionBn:
          'আপনি যে দেশে থাকেন সেখানে বৈধভাবে অবস্থানের প্রমাণ – যেমন ভিসা স্টিকার, ওয়ার্ক পারমিট, ইকামা, বিএআরপি, রেসিডেন্স কার্ড ইত্যাদির পরিষ্কার ছবি/স্ক্যান।',
      icon: Icons.airplane_ticket_outlined,
      colorValue: 0xFF0EA5E9,
    ),
    _DocumentItemData(
      id: 'address',
      titleEn: 'Overseas address proof',
      titleBn: 'বিদেশের ঠিকানার প্রমাণ',
      descriptionEn:
          'Document that shows your full name and current overseas address: utility bill, bank statement, tenancy contract, tax paper, or similar.',
      descriptionBn:
          'যে কাগজে আপনার পূর্ণ নাম ও বর্তমান বিদেশি ঠিকানা থাকে – যেমন গ্যাস/বিদ্যুৎ/ইন্টারনেট বিল, ব্যাংক স্টেটমেন্ট, ভাড়ার চুক্তিপত্র, ট্যাক্স পেপার ইত্যাদি।',
      icon: Icons.home_work_outlined,
      colorValue: 0xFF22C55E,
    ),
    _DocumentItemData(
      id: 'photo',
      titleEn: 'Good Lighting for live photo',
      titleBn: 'লাইভ ছবির জন্য ভালো আলো',
      descriptionEn:
          'The Postal Vote BD system uses face recognition with liveness check. Make sure your face is clearly visible, without heavy shadows, cap or sunglasses.',
      descriptionBn:
          'Postal Vote BD সিস্টেমে লাইভনেস চেকসহ ফেস রেকগনিশন ব্যবহার হয়। আপনার মুখ যেন পরিষ্কার দেখা যায় তা নিশ্চিত করুন – খুব বেশি ছায়া, টুপি বা সানগ্লাস যেন না থাকে।',
      icon: Icons.photo_camera_outlined,
      colorValue: 0xFFA855F7,
    ),
    _DocumentItemData(
      id: 'contact',
      titleEn: 'Active mobile number & email',
      titleBn: 'সক্রিয় মোবাইল নাম্বার ও ইমেইল',
      descriptionEn:
          'Keep a phone number and email that you can access during registration. They may be used for OTP codes, updates and ballot tracking.',
      descriptionBn:
          'নিবন্ধনের সময় যেগুলো ব্যবহার করতে পারবেন এমন মোবাইল নম্বর ও ইমেইল ঠিকানা প্রস্তুত রাখুন। ওটিপি কোড, আপডেট ও ব্যালট ট্র্যাকিংয়ের জন্য এগুলো লাগতে পারে।',
      icon: Icons.phone_iphone_outlined,
      colorValue: 0xFFF97316,
    ),
  ];

  late List<bool> _checkedStates;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkedStates = List<bool>.filled(_itemsData.length, false);
    _loadChecklistState();
  }

  Future<void> _loadChecklistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_prefsKey);

      if (stored != null && stored.length == _itemsData.length) {
        if (!mounted) return;
        setState(() {
          for (int i = 0; i < _itemsData.length; i++) {
            _checkedStates[i] = stored[i] == 'true';
          }
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChecklistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final values = _checkedStates.map((state) => state.toString()).toList();
      await prefs.setStringList(_prefsKey, values);
    } catch (e) {
      debugPrint('Error saving checklist state: $e');
    }
  }

  void _toggleItem(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _checkedStates[index] = !_checkedStates[index];
    });
    _saveChecklistState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final preparedCount = _checkedStates.where((state) => state).length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allDone = preparedCount == _itemsData.length && _itemsData.isNotEmpty;
    final progress = _itemsData.isEmpty
        ? 0.0
        : preparedCount / _itemsData.length.toDouble();

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final horizontalPadding = isWide ? (screenWidth - 600) / 2 : 20.0;

    String t(String en, String bn) => tr(widget.language, en, bn);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF020617)
          : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDark, t),
      body: _buildBody(
        preparedCount: preparedCount,
        isDark: isDark,
        allDone: allDone,
        progress: progress,
        horizontalPadding: horizontalPadding,
        t: t,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    bool isDark,
    String Function(String, String) t,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        t('Documents Checklist', 'প্রয়োজনীয় কাগজপত্র চেকলিস্ট'),
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildBody({
    required int preparedCount,
    required bool isDark,
    required bool allDone,
    required double progress,
    required double horizontalPadding,
    required String Function(String, String) t,
  }) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      children: [
        _ProgressCard(
          language: widget.language,
          preparedCount: preparedCount,
          totalCount: _itemsData.length,
          progress: progress,
          allDone: allDone,
          isDark: isDark,
        ),
        const SizedBox(height: 24),
        _InfoBanner(isDark: isDark, language: widget.language),
        const SizedBox(height: 24),
        for (int i = 0; i < _itemsData.length; i++) ...[
          _DocumentCard(
            data: _itemsData[i],
            language: widget.language,
            isChecked: _checkedStates[i],
            onTap: () => _toggleItem(i),
            isDark: isDark,
          ),
          if (i < _itemsData.length - 1) const SizedBox(height: 16),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}

@immutable
class _DocumentItemData {
  final String id;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;
  final int colorValue;

  const _DocumentItemData({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.icon,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  String title(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleBn;

  String description(AppLanguage language) =>
      language == AppLanguage.en ? descriptionEn : descriptionBn;
}

class _ProgressCard extends StatelessWidget {
  final AppLanguage language;
  final int preparedCount;
  final int totalCount;
  final double progress;
  final bool allDone;
  final bool isDark;

  const _ProgressCard({
    required this.language,
    required this.preparedCount,
    required this.totalCount,
    required this.progress,
    required this.allDone,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t('Progress', 'অগ্রগতি'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$preparedCount / $totalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            allDone
                ? t('🎉 All documents prepared!', '🎉 সব কাগজপত্র প্রস্তুত!')
                : '${(progress * 100).toInt()}% ${t('complete', 'সম্পন্ন')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;

  const _InfoBanner({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.amber.withOpacity(0.1) : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.amber.withOpacity(0.2) : Colors.amber.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark ? Colors.amber.shade400 : Colors.amber.shade700,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t(
                'These items are based on current public information about overseas postal voting. The official Postal Vote BD app may ask for extra documents depending on your country. Always follow the latest instructions from the Election Commission or your embassy/mission.',
                'বিদেশে ডাক ভোটের বিষয়ে বর্তমানে প্রচলিত তথ্যের ভিত্তিতে এই চেকলিস্ট তৈরি করা হয়েছে। আপনার দেশে পরিস্থিতি অনুযায়ী Postal Vote BD অ্যাপ অতিরিক্ত কাগজপত্র চাইতে পারে। সব সময় নির্বাচন কমিশন বা দূতাবাসের সর্বশেষ নির্দেশনা অনুসরণ করুন।',
              ),
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final _DocumentItemData data;
  final AppLanguage language;
  final bool isChecked;
  final VoidCallback onTap;
  final bool isDark;

  const _DocumentCard({
    required this.data,
    required this.language,
    required this.isChecked,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isDark
            ? (isChecked
                  ? data.color.withOpacity(0.16)
                  : const Color(0xFF0F172A))
            : (isChecked ? data.color.withOpacity(0.08) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isChecked
              ? data.color.withOpacity(0.6)
              : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06)),
          width: isChecked ? 2 : 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: isChecked
                      ? data.color.withOpacity(0.18)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: data.color.withOpacity(0.12),
          highlightColor: data.color.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(data.icon, color: data.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title(language),
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.description(language),
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? Colors.white.withOpacity(0.75)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _CustomCheckbox(
                  isChecked: isChecked,
                  color: data.color,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final Color color;
  final bool isDark;

  const _CustomCheckbox({
    required this.isChecked,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isChecked ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked
              ? color
              : (isDark
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2)),
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
          : null,
    );
  }
}
