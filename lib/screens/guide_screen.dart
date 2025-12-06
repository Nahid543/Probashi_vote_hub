import 'package:flutter/material.dart';
import '../lang/app_language.dart';

class GuideScreen extends StatelessWidget {
  final AppLanguage language;

  const GuideScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String t(String en, String bn) => tr(language, en, bn);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          t('Step-by-step Guide', 'ধাপে ধাপে গাইড'),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide
              ? (constraints.maxWidth - 600) / 2
              : 20.0;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            children: [
              _IntroCard(isDark: isDark, language: language),
              const SizedBox(height: 24),

              _SectionHeader(
                language: language,
                titleEn: 'Before you use the app',
                titleBn: 'অ্যাপ ব্যবহার করার আগে',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _StepCard(
                language: language,
                stepNumber: 1,
                icon: Icons.verified_user_rounded,
                titleEn: 'Check if you are eligible',
                titleBn: 'আপনি ভোট দেওয়ার যোগ্য কি না নিশ্চিত হন',
                bodyEn:
                    'You must be a Bangladeshi citizen of voting age with a valid NID and currently living abroad legally. Your postal vote will usually count in the constituency where you are already registered.',
                bodyBn:
                    'আপনাকে বাংলাদেশি নাগরিক হতে হবে, ভোট দেওয়ার বয়সে থাকতে হবে, বৈধ এনআইডি থাকতে হবে এবং আইনগতভাবে বিদেশে থাকতে হবে। সাধারণত আপনি যে আসনে আগে থেকেই ভোটার হিসেবে নিবন্ধিত, আপনার পোস্টাল ভোট সেই আসনেই গণনা হবে।',
                isDark: isDark,
              ),
              _StepCard(
                language: language,
                stepNumber: 2,
                icon: Icons.description_rounded,
                titleEn: 'Prepare your ID and documents',
                titleBn: 'প্রয়োজনীয় আইডি ও ডকুমেন্ট প্রস্তুত করুন',
                bodyEn:
                    'Keep your Smart NID information, passport (if you have one), overseas address, and active mobile number of the country where you are living. Also read any latest circular from the Election Commission or embassy.',
                bodyBn:
                    'আপনার স্মার্ট এনআইডির তথ্য, পাসপোর্ট (থাকলে), বিদেশের ঠিকানা এবং যেই দেশে থাকছেন সেই দেশের সক্রিয় মোবাইল নম্বর হাতের কাছে রাখুন। সাথে নির্বাচন কমিশন বা দূতাবাসের সর্বশেষ বিজ্ঞপ্তিও একবার দেখে নিন।',
                isDark: isDark,
              ),

              const SizedBox(height: 20),
              _SectionHeader(
                language: language,
                titleEn: 'Sign up and register in the Postal Vote BD app',
                titleBn: 'Postal Vote BD অ্যাপে সাইন আপ ও নিবন্ধন',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _StepCard(
                language: language,
                stepNumber: 3,
                icon: Icons.phone_android_rounded,
                titleEn: 'Install the official app only',
                titleBn: 'শুধু অফিসিয়াল অ্যাপ ইনস্টল করুন',
                bodyEn:
                    'Download "Postal Vote BD" only from the official Google Play Store or Apple App Store. Do not install APK files from unknown links or websites.',
                bodyBn:
                    'শুধু গুগল প্লে স্টোর অথবা অ্যাপল অ্যাপ স্টোর থেকে "Postal Vote BD" অফিসিয়াল অ্যাপ ডাউনলোড করুন। অজানা লিংক বা ওয়েবসাইট থেকে কখনও APK ইনস্টল করবেন না।',
                isDark: isDark,
              ),
              _StepCard(
                language: language,
                stepNumber: 4,
                icon: Icons.smartphone_rounded,
                titleEn: 'Create your account with overseas mobile number',
                titleBn: 'বিদেশি মোবাইল নম্বর দিয়ে অ্যাকাউন্ট খুলুন',
                bodyEn:
                    'Open the app, choose Bangla or English, then start enrolment. Enter the mobile number from the country where you will vote, receive the SMS code (OTP), and verify your number. Never share this code with anyone.',
                bodyBn:
                    'অ্যাপ চালু করে বাংলা বা ইংরেজি বেছে নিন, তারপর এনরোলমেন্ট শুরু করুন। যেই দেশ থেকে ভোট দেবেন সেই দেশের মোবাইল নম্বর দিন, এসএমএসে পাওয়া ওটিপি কোড দিয়ে নম্বর ভেরিফাই করুন। এই কোড কখনও কারও সাথে শেয়ার করবেন না।',
                isDark: isDark,
              ),
              _StepCard(
                language: language,
                stepNumber: 5,
                icon: Icons.face_rounded,
                titleEn: 'Complete identity verification (NID, eKYC, face)',
                titleBn:
                    'পরিচয় যাচাই সম্পূর্ণ করুন (এনআইডি, eKYC, মুখের যাচাই)',
                bodyEn:
                    'Provide your NID number and other information as asked in the app. Follow the on-screen eKYC steps, which may include scanning your NID and doing facial verification with liveness check. Add passport details if requested.',
                bodyBn:
                    'অ্যাপে যেভাবে চাওয়া হবে সেভাবে আপনার এনআইডি নম্বর ও অন্যান্য তথ্য দিন। স্ক্রিনে দেখানো eKYC ধাপগুলো (যেমন এনআইডি স্ক্যান, মুখের লিভনেস ভেরিফিকেশন ইত্যাদি) সম্পূর্ণ করুন। প্রয়োজন হলে পাসপোর্টের তথ্যও যোগ করুন।',
                isDark: isDark,
              ),
              _StepCard(
                language: language,
                stepNumber: 6,
                icon: Icons.location_on_rounded,
                titleEn: 'Add your full overseas postal address carefully',
                titleBn: 'বিদেশের পূর্ণ পোস্টাল ঠিকানা খুব ভালোভাবে লিখুন',
                bodyEn:
                    'Enter your house/building, street, area, city, postal code and country in clear English, exactly as used by the local postal service. An incomplete or wrong address can delay or stop your ballot from being delivered.',
                bodyBn:
                    'আপনার বাড়ি/বিল্ডিং, রাস্তা, এলাকা, শহর, পোস্টাল কোড এবং দেশ পরিষ্কার ইংরেজিতে লিখুন, যেভাবে স্থানীয় পোস্টাল সার্ভিস ব্যবহার করে। ভুল বা অসম্পূর্ণ ঠিকানা দিলে আপনার ব্যালট পেপার পৌঁছাতে দেরি হতে পারে বা পৌঁছাতেই নাও পারে।',
                isDark: isDark,
              ),

              const SizedBox(height: 20),
              _SectionHeader(
                language: language,
                titleEn: 'After you submit your registration',
                titleBn: 'নিবন্ধন সাবমিট করার পর',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _StepCard(
                language: language,
                stepNumber: 7,
                icon: Icons.notifications_active_rounded,
                titleEn: 'Submit, then follow status and messages',
                titleBn: 'আবেদন সাবমিট করে স্ট্যাটাস ও বার্তা দেখুন',
                bodyEn:
                    'Before submitting, review all details again. After you submit, keep any reference number or screenshot in a safe place. Check app notifications, SMS, or official announcements for registration status and deadlines.',
                bodyBn:
                    'সাবমিট করার আগে সব তথ্য আরেকবার দেখে নিন। সাবমিট করার পর যেকোনো রেফারেন্স নম্বর বা স্ক্রিনশট নিরাপদে রেখে দিন। নিবন্ধনের স্ট্যাটাস ও ডেডলাইনের খবর পেতে অ্যাপের নোটিফিকেশন, এসএমএস এবং অফিসিয়াল ঘোষণাগুলো খেয়াল করুন।',
                isDark: isDark,
              ),
              _StepCard(
                language: language,
                stepNumber: 8,
                icon: Icons.mail_rounded,
                titleEn: 'Receive your ballot, vote and send it back in time',
                titleBn: 'ব্যালট পেপার পেয়ে ভোট দিয়ে সময়মতো পাঠিয়ে দিন',
                bodyEn:
                    'When the ballot envelope arrives, follow the written instructions and any guidance in the app. Scan the QR code if asked, mark your choice on the paper ballot, complete the declaration form, seal the envelopes properly, and send it back by post before the deadline.',
                bodyBn:
                    'ব্যালটের খাম পৌঁছালে খামের সঙ্গে থাকা নির্দেশনা এবং অ্যাপে দেওয়া গাইডলাইন ভালোভাবে অনুসরণ করুন। প্রয়োজন হলে কিউআর কোড স্ক্যান করুন, কাগজের ব্যালটে আপনার পছন্দের প্রতীকে ভোট দিন, ডিক্লারেশন ফর্ম পূরণ করুন, খামগুলো সঠিকভাবে সিল করে ডেডলাইনের আগেই ডাকযোগে পাঠিয়ে দিন।',
                isDark: isDark,
              ),

              const SizedBox(height: 20),
              _InfoFooter(language: language, isDark: isDark),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;

  const _IntroCard({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.info_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t('How postal voting works', 'পোস্টাল ভোট কীভাবে কাজ করে'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            t(
              'This guide gives a general picture of the Postal Vote BD process for Bangladeshi citizens living abroad. The exact steps inside the official app, required documents and dates may change for each election.',
              'বিদেশে বসবাসকারী বাংলাদেশি নাগরিকদের জন্য Postal Vote BD প্রক্রিয়ার একটি সাধারণ ধারণা এখানে দেওয়া হয়েছে। অফিসিয়াল অ্যাপের ভেতরের ধাপ, প্রয়োজনীয় ডকুমেন্ট ও তারিখ প্রতিটি নির্বাচনে পরিবর্তিত হতে পারে।',
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final AppLanguage language;
  final String titleEn;
  final String titleBn;
  final bool isDark;

  const _SectionHeader({
    required this.language,
    required this.titleEn,
    required this.titleBn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t(titleEn, titleBn),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final AppLanguage language;
  final int stepNumber;
  final IconData icon;
  final String titleEn;
  final String titleBn;
  final String bodyEn;
  final String bodyBn;
  final bool isDark;

  const _StepCard({
    required this.language,
    required this.stepNumber,
    required this.icon,
    required this.titleEn,
    required this.titleBn,
    required this.bodyEn,
    required this.bodyBn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.15),
                    theme.colorScheme.primary.withOpacity(0.08),
                  ],
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: 24, color: theme.colorScheme.primary),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    t(titleEn, titleBn),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t(bodyEn, bodyBn),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoFooter extends StatelessWidget {
  final AppLanguage language;
  final bool isDark;

  const _InfoFooter({required this.language, required this.isDark});

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(0.5)
            : Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t(
                'This guide is for general understanding only. The Election Commission may change the exact steps, required documents, or dates for each election. Always follow the latest instructions, circulars, and FAQs from the official Election Commission or embassy channels.',
                'এই গাইডটি শুধুমাত্র সাধারণ ধারণা দেওয়ার জন্য। প্রতিটি নির্বাচনের জন্য নির্বাচন কমিশন নির্দিষ্ট ধাপ, প্রয়োজনীয় ডকুমেন্ট বা তারিখ পরিবর্তন করতে পারে। সব সময় নির্বাচন কমিশন বা দূতাবাসের অফিসিয়াল নির্দেশনা, বিজ্ঞপ্তি ও প্রশ্নোত্তর (FAQ) ভালোভাবে পড়ে অনুসরণ করুন।',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.6,
                fontSize: 13,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
