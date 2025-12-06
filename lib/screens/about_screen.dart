import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../lang/app_language.dart';

class AboutScreen extends StatelessWidget {
  final AppLanguage language;

  const AboutScreen({super.key, required this.language});

  String t(String en, String bn) => tr(language, en, bn);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final horizontalPadding = isWide ? (screenWidth - 600) / 2 : 20.0;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
          t('About & Disclaimer', 'অ্যাপ সম্পর্কে ও দায় স্বীকার'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        children: [
          _buildHeaderCard(isDark),
          const SizedBox(height: 20),
          _buildWhatThisAppDoesCard(isDark),
          const SizedBox(height: 16),
          _buildNotOfficialCard(isDark),
          const SizedBox(height: 16),
          _buildOfficialSourcesCard(context, isDark),
          const SizedBox(height: 16),
          _buildPrivacyCard(isDark),
          const SizedBox(height: 16),
          _buildLimitsCard(isDark),
          const SizedBox(height: 24),
          _buildVersionNote(context, isDark),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.35),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.how_to_vote_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Probashi Vote Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t(
                    'An unofficial helper app to make it easier for Bangladeshi citizens living abroad to understand and prepare for postal voting.',
                    'প্রবাসে থাকা বাংলাদেশি ভোটারদের জন্য ডাকযোগে ভোটের প্রক্রিয়া সহজভাবে বোঝা ও প্রস্তুতি নেওয়ার উদ্দেশ্যে তৈরি একটি অনানুষ্ঠানিক সহায়ক অ্যাপ।',
                  ),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatThisAppDoesCard(bool isDark) {
    return _AboutCard(
      isDark: isDark,
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFF6366F1),
      title: t('What this app does', 'এই অ্যাপ কী করে'),
      children: [
        _BulletLine(
          text: t(
            'Explains the basic steps of postal voting in simple language so you can follow the official process with more confidence.',
            'সরকারি ডাকযোগে ভোটের মূল ধাপগুলো সহজ ভাষায় ব্যাখ্যা করে, যাতে আপনি অফিসিয়াল প্রক্রিয়াটি আত্মবিশ্বাসের সাথে অনুসরণ করতে পারেন।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'Provides helper tools like a documents checklist, address format helper and key dates planner.',
            'ডকুমেন্ট চেকলিস্ট, ঠিকানা লেখার সহায়ক এবং গুরুত্বপূর্ণ তারিখ পরিকল্পনার মতো টুল দিয়ে আপনাকে গুছিয়ে প্রস্তুতি নিতে সাহায্য করে।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'Keeps everything on your device only – it does not send your information to any custom server from this app.',
            'আপনার তথ্য কেবল আপনার ফোনেই থাকে – এই অ্যাপ কোনো নিজস্ব সার্ভারে আপনার ডেটা পাঠায় না।',
          ),
        ),
      ],
    );
  }

  Widget _buildNotOfficialCard(bool isDark) {
    return _AboutCard(
      isDark: isDark,
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFF59E0B),
      title: t(
        'Not an official Election Commission app',
        'এটি নির্বাচন কমিশনের অফিসিয়াল অ্যাপ নয়',
      ),
      accentBorderColor: isDark ? const Color(0xFFF59E0B).withOpacity(0.4) : null,
      children: [
        _BulletLine(
          text: t(
            'This app is not developed, owned or managed by the Bangladesh Election Commission (EC), any embassy/mission, or any political party.',
            'এই অ্যাপ বাংলাদেশ নির্বাচন কমিশন (EC), কোনো দূতাবাস/মিশন বা কোনো রাজনৈতিক দলের তৈরি, মালিকানাধীন বা পরিচালিত নয়।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'The only official mobile app for postal voting is currently the "Postal Vote BD" app published by the Bangladesh Election Commission. This guide app is completely separate and cannot register you or track your ballot.',
            'ডাকযোগে ভোটের জন্য বর্তমানে বাংলাদেশ নির্বাচন কমিশন প্রকাশিত অফিসিয়াল মোবাইল অ্যাপ হলো "Postal Vote BD"। এই গাইড অ্যাপটি সম্পূর্ণ আলাদা, এটি কোনোভাবেই আপনাকে নিবন্ধন করতে পারে না বা আপনার ব্যালট ট্র্যাক করতে পারে না।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'Always rely on official notices, circulars, the Postal Vote BD app and embassy/mission announcements if there is any difference with this helper app.',
            'এই অ্যাপের তথ্যের সাথে কোনো অমিল হলে সবসময় অফিসিয়াল বিজ্ঞপ্তি, সার্কুলার, Postal Vote BD অ্যাপ এবং দূতাবাস/মিশনের ঘোষণাকেই অগ্রাধিকার দিন।',
          ),
        ),
      ],
    );
  }

  Widget _buildOfficialSourcesCard(BuildContext context, bool isDark) {
    return _AboutCard(
      isDark: isDark,
      icon: Icons.public_rounded,
      iconColor: const Color(0xFF0EA5E9),
      title: t('Official sources & links', 'অফিসিয়াল সোর্স ও লিংক'),
      children: [
        _BulletLine(
          text: t(
            'For any final decision, always use official Election Commission sources and the official Postal Vote BD app. These links open in your browser or Play Store.',
            'কোনো চূড়ান্ত সিদ্ধান্তের ক্ষেত্রে সবসময় নির্বাচন কমিশনের অফিসিয়াল সোর্স এবং অফিসিয়াল Postal Vote BD অ্যাপ ব্যবহার করুন। নিচের লিংকগুলো আপনার ব্রাউজার বা প্লে স্টোরে খুলবে।',
          ),
        ),
        const SizedBox(height: 10),
        _OfficialLinkTile(
          label: t(
            'Bangladesh Election Commission – ecs.gov.bd',
            'বাংলাদেশ নির্বাচন কমিশন – ecs.gov.bd',
          ),
          url: 'https://www.ecs.gov.bd',
        ),
        const SizedBox(height: 6),
        _OfficialLinkTile(
          label: t(
            'EC portal & notices – ecs.portal.gov.bd',
            'নির্বাচন কমিশন পোর্টাল ও নোটিশ – ecs.portal.gov.bd',
          ),
          url: 'https://ecs.portal.gov.bd',
        ),
        const SizedBox(height: 6),
        _OfficialLinkTile(
          label: t(
            'How to fill address in Postal Vote BD app (official guide)',
            'Postal Vote BD অ্যাপে ঠিকানা কীভাবে লিখবেন (অফিসিয়াল গাইড)',
          ),
          url:
              'https://www.ecs.gov.bd/page/how-to-fill-up-address-in-postal-vote-bd-mobile-app',
        ),
        const SizedBox(height: 6),
        _OfficialLinkTile(
          label: t(
            'Official "Postal Vote BD" app (Google Play)',
            'অফিসিয়াল "Postal Vote BD" অ্যাপ (Google Play)',
          ),
          url:
              'https://play.google.com/store/apps/details?id=bd.gov.ocv.postalvoting',
        ),
      ],
    );
  }

  Widget _buildPrivacyCard(bool isDark) {
    return _AboutCard(
      isDark: isDark,
      icon: Icons.lock_outline_rounded,
      iconColor: const Color(0xFF10B981),
      title: t(
        'Privacy & data in this app',
        'এই অ্যাপে আপনার ডেটা ও গোপনীয়তা',
      ),
      children: [
        _BulletLine(
          text: t(
            'This version of Probashi Vote Hub works fully offline. Data you type (such as notes, dates and addresses) is stored locally on your device using standard storage (for example, SharedPreferences).',
            'Probashi Vote Hub-এর এই সংস্করণ সম্পূর্ণ অফলাইনভাবে কাজ করে। আপনি যে তথ্য লিখবেন (যেমন নোট, তারিখ, ঠিকানা), তা আপনার ডিভাইসেই স্থানীয়ভাবে (যেমন SharedPreferences এর মাধ্যমে) সংরক্ষিত হয়।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'The app does not create any online account, cloud backup or custom analytics. However, your phone or app store may still collect general crash or usage data as part of the operating system.',
            'এই অ্যাপ কোনো অনলাইন অ্যাকাউন্ট, ক্লাউড ব্যাকআপ বা কাস্টম অ্যানালিটিক্স তৈরি করে না। তবে আপনার ফোন বা অ্যাপ স্টোর অপারেটিং সিস্টেমের অংশ হিসেবে সাধারণ ক্র্যাশ বা ব্যবহার সংক্রান্ত ডেটা সংগ্রহ করতে পারে।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'Never share your full NID number, passport number or one-time passwords (OTP) inside unofficial apps. Only enter those details directly in official EC systems such as the Postal Vote BD app or government websites.',
            'আপনার সম্পূর্ণ এনআইডি নম্বর, পাসপোর্ট নম্বর বা ওয়ান-টাইম পাসওয়ার্ড (OTP) কখনও অনানুষ্ঠানিক অ্যাপে দেবেন না। এসব তথ্য কেবল নির্বাচন কমিশনের অফিসিয়াল সিস্টেম, যেমন Postal Vote BD অ্যাপ বা সরকারি ওয়েবসাইটে সরাসরি দিন।',
          ),
        ),
      ],
    );
  }

  Widget _buildLimitsCard(bool isDark) {
    return _AboutCard(
      isDark: isDark,
      icon: Icons.policy_outlined,
      iconColor: const Color(0xFF3B82F6),
      title: t('Limitations & responsibility', 'সীমাবদ্ধতা ও দায়িত্ব'),
      children: [
        _BulletLine(
          text: t(
            'Information in this app is for general guidance only. Laws, rules and technical details of the postal voting system can change quickly.',
            'এই অ্যাপের তথ্য কেবল সাধারণ নির্দেশনার উদ্দেশ্যে। ডাকযোগে ভোটের আইন, নিয়ম এবং প্রযুক্তিগত বিষয়গুলো দ্রুত পরিবর্তিত হতে পারে।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'Before making any final decision, always read the latest instructions from the Bangladesh Election Commission and your local embassy/mission.',
            'কোনো চূড়ান্ত সিদ্ধান্ত নেওয়ার আগে অবশ্যই বাংলাদেশ নির্বাচন কমিশন এবং আপনার দেশের দূতাবাস/মিশনের সর্বশেষ নির্দেশনা পড়ে নিন।',
          ),
        ),
        const SizedBox(height: 8),
        _BulletLine(
          text: t(
            'The developer of this app cannot take responsibility if your registration or ballot is delayed or rejected because of incorrect information you provided.',
            'আপনি যে তথ্য প্রদান করবেন তার ভুলের কারণে আপনার নিবন্ধন বা ব্যালট বিলম্বিত বা বাতিল হলে এর জন্য এই অ্যাপের ডেভেলপার দায়ভার নিতে পারবে না।',
          ),
        ),
      ],
    );
  }

  Widget _buildVersionNote(BuildContext context, bool isDark) {
    final textColor =
        isDark ? Colors.white.withOpacity(0.6) : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('App version & feedback', 'অ্যাপের সংস্করণ ও মতামত'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                isDark ? Colors.white.withOpacity(0.85) : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          t(
            'This is an early version of Probashi Vote Hub. If you notice any outdated information or have a suggestion to improve the app, please update from the Play Store when a new release is available and follow the latest official notices.',
            'Probashi Vote Hub-এর এটি একটি প্রাথমিক সংস্করণ। আপনার কাছে কোনো তথ্য পুরনো মনে হলে বা অ্যাপ উন্নত করার মতো কোনো পরামর্শ থাকলে নতুন আপডেট এলে প্লে স্টোর থেকে আপডেট করুন এবং সর্বশেষ অফিসিয়াল নির্দেশনা অনুসরণ করুন।',
          ),
          style: TextStyle(fontSize: 12, height: 1.5, color: textColor),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;
  final Color? accentBorderColor;

  const _AboutCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
    this.accentBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF020617) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentBorderColor ??
              (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.06)),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;

  const _BulletLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : const Color(0xFF0F172A).withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}

class _OfficialLinkTile extends StatelessWidget {
  final String label;
  final String url;

  const _OfficialLinkTile({
    required this.label,
    required this.url,
  });

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      final ok = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open link',
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open link',
            style: TextStyle(fontSize: 13),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openLink(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFE5F2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF1D4ED8),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF1F2933),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
