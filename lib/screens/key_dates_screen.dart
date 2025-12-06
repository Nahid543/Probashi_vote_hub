import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../lang/app_language.dart';

class KeyDatesScreen extends StatefulWidget {
  final AppLanguage language;

  const KeyDatesScreen({super.key, required this.language});

  @override
  State<KeyDatesScreen> createState() => _KeyDatesScreenState();
}

class _KeyDatesScreenState extends State<KeyDatesScreen>
    with SingleTickerProviderStateMixin {
  late _CountryOption _selected;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selected = _countryOptions.first;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<_CountryOption> get _filteredCountries {
    if (_searchQuery.isEmpty) return _countryOptions;
    return _countryOptions.where((country) {
      final nameEn = country.nameEn.toLowerCase();
      final nameBn = country.nameBn.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return nameEn.contains(query) || nameBn.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final horizontalPadding = isWide ? (size.width - 600) / 2 : 16.0;

    String t(String en, String bn) => tr(widget.language, en, bn);

    final region = _regionById[_selected.regionId]!;
    final bool isGccSuspensionCountry = _gccSuspensionCountryCodes.contains(
      _selected.code,
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E27)
          : const Color(0xFFF1F5F9),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, isDark, t),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Animated entrance for global window card
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(_fadeAnimation),
                      child: _GlobalWindowCard(
                        isDark: isDark,
                        language: widget.language,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Country picker section with modern design
                  _buildSectionHeader(
                    context,
                    t(
                      'Check your country / region',
                      'আপনার দেশ / অঞ্চল নির্বাচন করুন',
                    ),
                    Icons.location_on_rounded,
                    isDark,
                  ),
                  const SizedBox(height: 12),

                  _buildModernCountryPicker(context, isDark, t),

                  const SizedBox(height: 20),

                  _RegionDetailsCard(
                    language: widget.language,
                    region: region,
                    selectedCountry: _selected,
                  ),

                  if (isGccSuspensionCountry) ...[
                    const SizedBox(height: 16),
                    _GccSuspensionInfo(language: widget.language),
                  ],

                  const SizedBox(height: 20),
                  _PlanningTips(language: widget.language),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    String Function(String, String) t,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
      title: Text(
        t('Key Dates & Registration', 'মূল তারিখ ও নিবন্ধন সময়'),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? Colors.white.withOpacity(0.95)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernCountryPicker(
    BuildContext context,
    bool isDark,
    String Function(String, String) t,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151B3D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showCountryPickerModal(context, isDark, t),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('Country where you live now', 'আপনি যে দেশে থাকেন'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.15),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.flag_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.language == AppLanguage.en
                            ? _selected.nameEn
                            : _selected.nameBn,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black54,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  t(
                    'Tap to change country and see specific registration dates',
                    'দেশ পরিবর্তন করতে এবং নির্দিষ্ট তারিখ দেখতে ট্যাপ করুন',
                  ),
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryPickerModal(
    BuildContext context,
    bool isDark,
    String Function(String, String) t,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredList = _filteredCountries;

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151B3D) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('Select Country', 'দেশ নির্বাচন করুন'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search field
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          setModalState(() => _searchQuery = value);
                        },
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: t('Search country...', 'দেশ খুঁজুন...'),
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black45,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black54,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: isDark
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.black54,
                                  ),
                                  onPressed: () {
                                    setModalState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Country list
                Expanded(
                  child: filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: isDark
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.black26,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                t(
                                  'No countries found',
                                  'কোনো দেশ পাওয়া যায়নি',
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          itemBuilder: (context, index) {
                            final country = filteredList[index];
                            final isSelected = country.code == _selected.code;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _selected = country);
                                  Navigator.pop(context);
                                  _searchController.clear();
                                  _searchQuery = '';
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.15)
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.08))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.2),
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.flag_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          widget.language == AppLanguage.en
                                              ? country.nameEn
                                              : country.nameBn,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          size: 22,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// Global registration window card with "See official link" button
// ------------------------------------------------------------------

class _GlobalWindowCard extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;

  const _GlobalWindowCard({required this.isDark, required this.language});

  Future<void> _openOfficialSite(BuildContext context) async {
    final uri = Uri.parse('https://ecs.gov.bd/');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        _showError(context);
      }
    } catch (_) {
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tr(
            language,
            'Could not open the Election Commission website.',
            'নির্বাচন কমিশনের ওয়েবসাইট খোলা যায়নি।',
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t('Global Registration Window*', 'বৈশ্বিক নিবন্ধন সময়*'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              t(
                'Registration through Postal Vote BD app is open worldwide from 27 November 2025, 12:01 am to 18 December 2025, 11:59 pm (Bangladesh time).',
                'Postal Vote BD অ্যাপের মাধ্যমে নিবন্ধন বিশ্বের সব দেশে ২৭ নভেম্বর ২০২৫ রাত ১২:০১ থেকে ১৮ ডিসেম্বর ২০২৫ রাত ১১:৫৯ পর্যন্ত (বাংলাদেশ সময়) চালু রয়েছে।',
              ),
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            t(
              '*Always confirm latest dates on the official Election Commission or embassy website.',
              '*তারিখ সম্পর্কে সর্বশেষ তথ্য জানতে অবশ্যই নির্বাচন কমিশন বা দূতাবাসের অফিসিয়াল ওয়েবসাইট দেখুন।',
            ),
            style: TextStyle(
              fontSize: 11.5,
              height: 1.5,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _openOfficialSite(context),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(
              t('See official link', 'অফিসিয়াল লিংক দেখুন'),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Region details for selected country
// ------------------------------------------------------------------

class _RegionDetailsCard extends StatelessWidget {
  final AppLanguage language;
  final _RegionInfo region;
  final _CountryOption selectedCountry;

  const _RegionDetailsCard({
    required this.language,
    required this.region,
    required this.selectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151B3D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.public_rounded,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('Selected Country', 'নির্বাচিত দেশ'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withOpacity(0.6)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      language == AppLanguage.en
                          ? selectedCountry.nameEn
                          : selectedCountry.nameBn,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            t('Assigned Region', 'নির্ধারিত অঞ্চল'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            language == AppLanguage.en ? region.titleEn : region.titleBn,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        Colors.blueGrey.withOpacity(0.15),
                        Colors.blueGrey.withOpacity(0.08),
                      ]
                    : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t('Regional Window', 'আঞ্চলিক সময়সীমা'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white.withOpacity(0.9)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  language == AppLanguage.en
                      ? region.windowEn
                      : region.windowBn,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark
                        ? Colors.white.withOpacity(0.85)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text(
            language == AppLanguage.en
                ? region.descriptionEn
                : region.descriptionBn,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.6,
              color: isDark
                  ? Colors.white.withOpacity(0.75)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// GCC suspension info (Saudi Arabia, UAE, Qatar, etc.)
// ------------------------------------------------------------------

class _GccSuspensionInfo extends StatelessWidget {
  final AppLanguage language;

  const _GccSuspensionInfo({required this.language});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.amber.withOpacity(0.12) : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.amber.withOpacity(0.3) : Colors.amber.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 22,
            color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t(
                'The Election Commission has temporarily suspended registration in some Gulf countries in the past when many voters entered incomplete or wrong postal addresses. Always check the latest notice for your country and write your full address carefully in English with postcode.',
                'অনেক ভোটার অসম্পূর্ণ বা ভুল পোস্টাল ঠিকানা দেওয়ায় অতীতে কিছু উপসাগরীয় দেশে নিবন্ধন সাময়িকভাবে বন্ধ ছিল। আপনার দেশের সর্বশেষ বিজ্ঞপ্তি দেখে নিন এবং সব সময় পোস্টাল কোডসহ পূর্ণ ঠিকানা পরিষ্কার ইংরেজিতে লিখুন।',
              ),
              style: TextStyle(
                fontSize: 12.5,
                height: 1.6,
                color: isDark ? Colors.amber.shade100 : Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Planning tips footer
// ------------------------------------------------------------------

class _PlanningTips extends StatelessWidget {
  final AppLanguage language;

  const _PlanningTips({required this.language});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String t(String en, String bn) => tr(language, en, bn);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.withOpacity(0.12) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blue.withOpacity(0.3) : Colors.blue.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tips_and_updates_rounded,
            size: 22,
            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t(
                'Try not to wait until the last day. If possible, complete your registration a few days earlier so there is time for verification, printing and posting your ballot papers.',
                'শেষ দিনে অপেক্ষা না করাই ভালো। চেষ্টা করুন কয়েক দিন আগেই নিবন্ধন শেষ করতে, যেন যাচাই, প্রিন্টিং এবং পোস্টে ব্যালট পাঠানোর জন্য পর্যাপ্ত সময় থাকে।',
              ),
              style: TextStyle(
                fontSize: 12.5,
                height: 1.6,
                color: isDark ? Colors.blue.shade100 : const Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Data models & static config
// ------------------------------------------------------------------

enum _RegionId {
  eastAfricaSouthAmerica,
  northAmericaOceania,
  europe,
  saudiArabia,
  southSouthEastAsia,
  otherMiddleEast,
  otherOrUnknown,
}

class _RegionInfo {
  final _RegionId id;
  final String titleEn;
  final String titleBn;
  final String windowEn;
  final String windowBn;
  final String descriptionEn;
  final String descriptionBn;

  const _RegionInfo({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.windowEn,
    required this.windowBn,
    required this.descriptionEn,
    required this.descriptionBn,
  });
}

class _CountryOption {
  final String code;
  final String nameEn;
  final String nameBn;
  final _RegionId regionId;

  const _CountryOption({
    required this.code,
    required this.nameEn,
    required this.nameBn,
    required this.regionId,
  });
}

// Region info based on EC announcements
const Map<_RegionId, _RegionInfo> _regionById = {
  _RegionId.eastAfricaSouthAmerica: _RegionInfo(
    id: _RegionId.eastAfricaSouthAmerica,
    titleEn: 'East Asia, Africa & South America',
    titleBn: 'পূর্ব এশিয়া, আফ্রিকা ও দক্ষিণ আমেরিকা',
    windowEn:
        '19–23 November 2025 (initial five-day window), later extended until 28 November 2025 for many countries in this region.',
    windowBn:
        '১৯–২৩ নভেম্বর ২০২৫ (প্রাথমিক পাঁচ দিনের সময়কাল), পরে এই অঞ্চলের অনেক দেশের জন্য ২৮ নভেম্বর ২০২৫ পর্যন্ত বাড়ানো হয়।',
    descriptionEn:
        'This region covers countries such as South Korea, Japan, China, South Africa, Brazil, and others where many Bangladeshi citizens live. Even if the window was extended, always check the latest EC notice, because extensions can change.',
    descriptionBn:
        'এই অঞ্চলে দক্ষিণ কোরিয়া, জাপান, চীন, দক্ষিণ আফ্রিকা, ব্রাজিলসহ অনেক দেশ রয়েছে যেখানে বিপুলসংখ্যক বাংলাদেশি থাকেন। সময়সীমা বাড়ানো হলেও সর্বশেষ নির্বাচন কমিশনের বিজ্ঞপ্তি দেখে নিন, কারণ বাড়তি সময়ও পরিবর্তিত হতে পারে।',
  ),
  _RegionId.northAmericaOceania: _RegionInfo(
    id: _RegionId.northAmericaOceania,
    titleEn: 'North America & Oceania',
    titleBn: 'উত্তর আমেরিকা ও ওশেনিয়া',
    windowEn:
        '24–28 November 2025 (Bangladesh time) for countries such as the United States, Canada, Australia and New Zealand.',
    windowBn:
        '২৪–২৮ নভেম্বর ২০২৫ (বাংলাদেশ সময়) – যুক্তরাষ্ট্র, কানাডা, অস্ট্রেলিয়া, নিউজিল্যান্ডসহ অন্যান্য দেশের জন্য।',
    descriptionEn:
        'The EC initially set a single window of 24–28 November 2025 for these countries. Later notices opened global registration until 18 December 2025, so follow the newest instructions.',
    descriptionBn:
        'এই দেশগুলোর জন্য নির্বাচন কমিশন প্রথমে ২৪–২৮ নভেম্বর ২০২৫ একটি সময়সীমা নির্ধারণ করে। পরে বিজ্ঞপ্তিতে বৈশ্বিকভাবে ১৮ ডিসেম্বর ২০২৫ পর্যন্ত নিবন্ধন খোলা রাখা হয়, তাই সব সময় নতুন নির্দেশনা অনুসরণ করুন।',
  ),
  _RegionId.europe: _RegionInfo(
    id: _RegionId.europe,
    titleEn: 'Europe',
    titleBn: 'ইউরোপ',
    windowEn:
        '21 November – 3 December 2025 (Bangladesh time) for European countries such as the United Kingdom, Italy, Germany, Spain, France and others.',
    windowBn:
        '২১ নভেম্বর থেকে ৩ ডিসেম্বর ২০২৫ (বাংলাদেশ সময়) – যুক্তরাজ্য, ইতালি, জার্মানি, স্পেন, ফ্রান্সসহ ইউরোপের অন্যান্য দেশের জন্য।',
    descriptionEn:
        'For Europe, the EC announced a longer registration window so that missions and voters had more time. Later, when the process was opened globally, those later dates also applied to European voters.',
    descriptionBn:
        'ইউরোপের জন্য নির্বাচন কমিশন তুলনামূলক দীর্ঘ নিবন্ধন সময় ঘোষণা করেছে, যাতে দূতাবাস ও ভোটাররা পর্যাপ্ত সময় পায়। পরে যখন বৈশ্বিকভাবে সময় বাড়ানো হয়, তখন ইউরোপের ভোটারদের জন্যও সেই বাড়তি সময় প্রযোজ্য হয়।',
  ),
  _RegionId.saudiArabia: _RegionInfo(
    id: _RegionId.saudiArabia,
    titleEn: 'Saudi Arabia',
    titleBn: 'সৌদি আরব',
    windowEn:
        '4–8 December 2025 (Bangladesh time) as a dedicated window only for Saudi Arabia.',
    windowBn:
        '৪–৮ ডিসেম্বর ২০২৫ (বাংলাদেশ সময়) – শুধুমাত্র সৌদি আরবের জন্য আলাদা সময়সীমা।',
    descriptionEn:
        'Because a very large number of Bangladeshi citizens live in Saudi Arabia, the EC announced a separate registration phase. There have also been temporary suspensions when many users entered incomplete addresses, so always follow the latest Saudi-specific notices from the EC and embassy.',
    descriptionBn:
        'অনেক বেশি বাংলাদেশি সৌদি আরবে বসবাস করায় নির্বাচন কমিশন সেখানে আলাদা নিবন্ধন ধাপ ঘোষণা করেছে। অনেক ব্যবহারকারী অসম্পূর্ণ ঠিকানা দেওয়ায় এখানে কয়েকবার নিবন্ধন সাময়িকভাবে বন্ধও হয়েছে, তাই নির্বাচন কমিশন ও দূতাবাসের সৌদি-সংক্রান্ত সর্বশেষ বিজ্ঞপ্তি অবশ্যই অনুসরণ করুন।',
  ),
  _RegionId.southSouthEastAsia: _RegionInfo(
    id: _RegionId.southSouthEastAsia,
    titleEn: 'South Asia & South-East Asia',
    titleBn: 'দক্ষিণ এশিয়া ও দক্ষিণ-পূর্ব এশিয়া',
    windowEn:
        '9–13 December 2025 (Bangladesh time) for countries such as India, Nepal, Sri Lanka, Malaysia, Singapore and others in the region.',
    windowBn:
        '৯–১৩ ডিসেম্বর ২০২৫ (বাংলাদেশ সময়) – ভারত, নেপাল, শ্রীলঙ্কা, মালয়েশিয়া, সিঙ্গাপুরসহ এই অঞ্চলের অন্যান্য দেশের জন্য।',
    descriptionEn:
        'Many Bangladeshi workers and students live in this region. Make sure to follow the exact date and time given by the EC, as some missions may also share local reminders or cut-off times.',
    descriptionBn:
        'এই অঞ্চলে অনেক বাংলাদেশি কর্মী ও শিক্ষার্থী থাকেন। নির্বাচন কমিশন যে তারিখ ও সময় দিয়েছে তা ঠিকভাবে অনুসরণ করুন; অনেক ক্ষেত্রে স্থানীয় দূতাবাসও আলাদা করে স্মরণ করিয়ে দিতে পারে।',
  ),
  _RegionId.otherMiddleEast: _RegionInfo(
    id: _RegionId.otherMiddleEast,
    titleEn: 'Other Middle Eastern countries (except Saudi Arabia)',
    titleBn: 'অন্যান্য মধ্যপ্রাচ্যের দেশ (সৌদি আরব বাদে)',
    windowEn:
        '14–18 December 2025 (Bangladesh time) for countries such as the United Arab Emirates, Qatar, Kuwait, Oman, Bahrain and others.',
    windowBn:
        '১৪–১৮ ডিসেম্বর ২০২৫ (বাংলাদেশ সময়) – সংযুক্ত আরব আমিরাত, কাতার, কুয়েত, ওমান, বাহরাইনসহ অন্যান্য মধ্যপ্রাচ্যের দেশের জন্য (সৌদি আরব ছাড়া)।',
    descriptionEn:
        'The EC scheduled the final phase of registration for the remaining Middle Eastern countries where many Bangladeshi migrant workers live. Because of very high demand, it is better to register early in the window if possible.',
    descriptionBn:
        'যে সব মধ্যপ্রাচ্যের দেশে বিপুলসংখ্যক প্রবাসী বাংলাদেশি আছেন, তাদের জন্য এই শেষ ধাপের সময়সূচি নির্ধারণ করা হয়। চাহিদা বেশি থাকায় চেষ্টা করুন সম্ভব হলে সময়সীমার শুরুতেই নিবন্ধন করতে।',
  ),
  _RegionId.otherOrUnknown: _RegionInfo(
    id: _RegionId.otherOrUnknown,
    titleEn: 'Other country / not listed',
    titleBn: 'অন্যান্য দেশ / তালিকায় নেই',
    windowEn:
        'Your country is part of one of the regions above. If you are not sure which one, follow the global registration window (27 November – 18 December 2025) and check the Election Commission or embassy website for the exact cut-off date.',
    windowBn:
        'আপনার দেশ উপরের কোনো একটি অঞ্চলের অন্তর্ভুক্ত। যদি নিশ্চিত না হন, তাহলে বৈশ্বিক নিবন্ধন সময় (২৭ নভেম্বর – ১৮ ডিসেম্বর ২০২৫) ধরে এগোন এবং সঠিক শেষ তারিখ জানতে নির্বাচন কমিশন বা দূতাবাসের ওয়েবসাইট দেখে নিন।',
    descriptionEn:
        'This option is for countries that are not listed separately in the shortcut list inside this app. The official EC notice contains the full list of 148 countries; always rely on that list first.',
    descriptionBn:
        'এই অপশনটি এমন দেশগুলোর জন্য যেগুলো এই অ্যাপের শর্টকাট তালিকায় আলাদা করে দেওয়া হয়নি। নির্বাচন কমিশনের অফিসিয়াল বিজ্ঞপ্তিতে ১৪৮টি দেশের পূর্ণ তালিকা আছে; সবার আগে সেই তালিকাকে অনুসরণ করুন।',
  ),
};

// Country options list
const List<_CountryOption> _countryOptions = [
  // Gulf & Middle East
  _CountryOption(
    code: 'sa',
    nameEn: 'Saudi Arabia',
    nameBn: 'সৌদি আরব',
    regionId: _RegionId.saudiArabia,
  ),
  _CountryOption(
    code: 'ae',
    nameEn: 'United Arab Emirates',
    nameBn: 'সংযুক্ত আরব আমিরাত (ইউএই)',
    regionId: _RegionId.otherMiddleEast,
  ),
  _CountryOption(
    code: 'qa',
    nameEn: 'Qatar',
    nameBn: 'কাতার',
    regionId: _RegionId.otherMiddleEast,
  ),
  _CountryOption(
    code: 'kw',
    nameEn: 'Kuwait',
    nameBn: 'কুয়েত',
    regionId: _RegionId.otherMiddleEast,
  ),
  _CountryOption(
    code: 'om',
    nameEn: 'Oman',
    nameBn: 'ওমান',
    regionId: _RegionId.otherMiddleEast,
  ),
  _CountryOption(
    code: 'bh',
    nameEn: 'Bahrain',
    nameBn: 'বাহরাইন',
    regionId: _RegionId.otherMiddleEast,
  ),

  // South & South-East Asia
  _CountryOption(
    code: 'my',
    nameEn: 'Malaysia',
    nameBn: 'মালয়েশিয়া',
    regionId: _RegionId.southSouthEastAsia,
  ),
  _CountryOption(
    code: 'sg',
    nameEn: 'Singapore',
    nameBn: 'সিঙ্গাপুর',
    regionId: _RegionId.southSouthEastAsia,
  ),
  _CountryOption(
    code: 'in',
    nameEn: 'India',
    nameBn: 'ভারত',
    regionId: _RegionId.southSouthEastAsia,
  ),
  _CountryOption(
    code: 'lk',
    nameEn: 'Sri Lanka',
    nameBn: 'শ্রীলঙ্কা',
    regionId: _RegionId.southSouthEastAsia,
  ),
  _CountryOption(
    code: 'np',
    nameEn: 'Nepal',
    nameBn: 'নেপাল',
    regionId: _RegionId.southSouthEastAsia,
  ),

  // Europe
  _CountryOption(
    code: 'gb',
    nameEn: 'United Kingdom',
    nameBn: 'যুক্তরাজ্য',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'it',
    nameEn: 'Italy',
    nameBn: 'ইতালি',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'de',
    nameEn: 'Germany',
    nameBn: 'জার্মানি',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'fr',
    nameEn: 'France',
    nameBn: 'ফ্রান্স',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'es',
    nameEn: 'Spain',
    nameBn: 'স্পেন',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'pt',
    nameEn: 'Portugal',
    nameBn: 'পর্তুগাল',
    regionId: _RegionId.europe,
  ),
  _CountryOption(
    code: 'gr',
    nameEn: 'Greece',
    nameBn: 'গ্রিস',
    regionId: _RegionId.europe,
  ),

  // North America & Oceania
  _CountryOption(
    code: 'us',
    nameEn: 'United States',
    nameBn: 'যুক্তরাষ্ট্র',
    regionId: _RegionId.northAmericaOceania,
  ),
  _CountryOption(
    code: 'ca',
    nameEn: 'Canada',
    nameBn: 'কানাডা',
    regionId: _RegionId.northAmericaOceania,
  ),
  _CountryOption(
    code: 'au',
    nameEn: 'Australia',
    nameBn: 'অস্ট্রেলিয়া',
    regionId: _RegionId.northAmericaOceania,
  ),
  _CountryOption(
    code: 'nz',
    nameEn: 'New Zealand',
    nameBn: 'নিউজিল্যান্ড',
    regionId: _RegionId.northAmericaOceania,
  ),

  // East Asia, Africa, South America
  _CountryOption(
    code: 'kr',
    nameEn: 'South Korea',
    nameBn: 'দক্ষিণ কোরিয়া',
    regionId: _RegionId.eastAfricaSouthAmerica,
  ),
  _CountryOption(
    code: 'jp',
    nameEn: 'Japan',
    nameBn: 'জাপান',
    regionId: _RegionId.eastAfricaSouthAmerica,
  ),
  _CountryOption(
    code: 'cn',
    nameEn: 'China',
    nameBn: 'চীন',
    regionId: _RegionId.eastAfricaSouthAmerica,
  ),
  _CountryOption(
    code: 'za',
    nameEn: 'South Africa',
    nameBn: 'দক্ষিণ আফ্রিকা',
    regionId: _RegionId.eastAfricaSouthAmerica,
  ),
  _CountryOption(
    code: 'br',
    nameEn: 'Brazil',
    nameBn: 'ব্রাজিল',
    regionId: _RegionId.eastAfricaSouthAmerica,
  ),

  // Fallback option
  _CountryOption(
    code: 'other',
    nameEn: 'Other country / not in this list',
    nameBn: 'অন্য দেশ / এই তালিকায় নেই',
    regionId: _RegionId.otherOrUnknown,
  ),
];

// GCC suspension countries
const Set<String> _gccSuspensionCountryCodes = {
  'sa',
  'ae',
  'qa',
  'kw',
  'om',
  'bh',
  'my',
};
