import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/app_language.dart';

class AddressHelperScreen extends StatefulWidget {
  final AppLanguage language;

  const AddressHelperScreen({super.key, required this.language});

  @override
  State<AddressHelperScreen> createState() => _AddressHelperScreenState();
}

class _AddressHelperScreenState extends State<AddressHelperScreen> {
  static const _prefsCountryKey = 'address_helper_last_country_v3';
  static const _prefsAddressKey = 'address_helper_last_address_v3';

  final TextEditingController _addressController = TextEditingController();

  // Countries where EC temporarily suspended registration once
  // because of incomplete / wrong postal addresses.
  static const Set<String> _flaggedCountries = {
    'Saudi Arabia',
    'United Arab Emirates',
    'Qatar',
    'Oman',
    'Kuwait',
    'Bahrain',
    'Malaysia',
  };

  // Comprehensive country list - popular NRB destinations first
  static const List<String> _countries = [
    'Saudi Arabia',
    'United Arab Emirates',
    'Qatar',
    'Oman',
    'Kuwait',
    'Bahrain',
    'Malaysia',
    'Singapore',
    'United Kingdom',
    'Ireland',
    'United States',
    'Canada',
    'Australia',
    'Italy',
    'Germany',
    'France',
    'Spain',
    'Netherlands',
    'Belgium',
    'Sweden',
    'Norway',
    'Denmark',
    'Finland',
    'Switzerland',
    'Portugal',
    'Greece',
    'Austria',
    'Poland',
    'Turkey',
    'New Zealand',
    'Japan',
    'South Korea',
    'China',
    'India',
    'Thailand',
    'Indonesia',
    'Philippines',
    'Vietnam',
    'Pakistan',
    'Egypt',
    'South Africa',
    'Brazil',
    'Argentina',
    'Chile',
    'Mexico',
    'Colombia',
    'Peru',
    'Russia',
    'Ukraine',
    'Romania',
    'Czech Republic',
    'Hungary',
    'Croatia',
    'Serbia',
    'Bulgaria',
    'Slovakia',
    'Slovenia',
    'Lithuania',
    'Latvia',
    'Estonia',
    'Iceland',
    'Luxembourg',
    'Malta',
    'Cyprus',
    'Albania',
    'Bosnia and Herzegovina',
    'Montenegro',
    'North Macedonia',
    'Moldova',
    'Belarus',
    'Georgia',
    'Armenia',
    'Azerbaijan',
    'Kazakhstan',
    'Uzbekistan',
    'Kyrgyzstan',
    'Tajikistan',
    'Turkmenistan',
    'Afghanistan',
    'Iran',
    'Iraq',
    'Israel',
    'Jordan',
    'Lebanon',
    'Syria',
    'Yemen',
    'Libya',
    'Tunisia',
    'Algeria',
    'Morocco',
    'Sudan',
    'Ethiopia',
    'Kenya',
    'Tanzania',
    'Uganda',
    'Nigeria',
    'Ghana',
    'Senegal',
    'Ivory Coast',
    'Cameroon',
    'Zimbabwe',
    'Zambia',
    'Mozambique',
    'Angola',
    'Namibia',
    'Botswana',
    'Madagascar',
    'Mauritius',
    'Seychelles',
    'Maldives',
    'Sri Lanka',
    'Nepal',
    'Bhutan',
    'Myanmar',
    'Cambodia',
    'Laos',
    'Mongolia',
    'Taiwan',
    'Hong Kong',
    'Brunei',
    'Timor-Leste',
    'Papua New Guinea',
    'Fiji',
    'Samoa',
    'Tonga',
    'Vanuatu',
    'Solomon Islands',
    'New Caledonia',
    'Uruguay',
    'Paraguay',
    'Bolivia',
    'Ecuador',
    'Venezuela',
    'Guyana',
    'Suriname',
    'Panama',
    'Costa Rica',
    'Nicaragua',
    'Honduras',
    'El Salvador',
    'Guatemala',
    'Belize',
    'Jamaica',
    'Trinidad and Tobago',
    'Barbados',
    'Bahamas',
    'Cuba',
    'Dominican Republic',
    'Haiti',
    'Rwanda',
    'Burundi',
    'Somalia',
    'Eritrea',
    'Djibouti',
    'Malawi',
    'Lesotho',
    'Eswatini',
    'Mali',
    'Niger',
    'Chad',
    'Mauritania',
    'Burkina Faso',
    'Benin',
    'Togo',
    'Liberia',
    'Sierra Leone',
    'Guinea',
    'Gambia',
    'Guinea-Bissau',
    'Equatorial Guinea',
    'Gabon',
    'Congo',
    'Central African Republic',
    'Other',
  ];

  static const List<String> _formatComponents = [
    'House / Building',
    'Road / Street',
    'Area / District',
    'City / Town',
    'Region / State / Province',
    'Postcode / ZIP (if used)',
    'Country name',
  ];

  String _selectedCountry = 'Saudi Arabia';

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCountry = prefs.getString(_prefsCountryKey);
      final savedAddress = prefs.getString(_prefsAddressKey);

      if (!mounted) return;

      setState(() {
        if (savedCountry != null && _countries.contains(savedCountry)) {
          _selectedCountry = savedCountry;
        }
        if (savedAddress != null && savedAddress.isNotEmpty) {
          _addressController.text = savedAddress;
        }
      });
    } catch (e) {
      debugPrint('Error loading saved values: $e');
    }
  }

  Future<void> _saveValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsCountryKey, _selectedCountry);
      await prefs.setString(_prefsAddressKey, _addressController.text.trim());
    } catch (e) {
      debugPrint('Error saving values: $e');
    }
  }

  String _buildFormattedAddress() {
    final raw = _addressController.text.trim();
    if (raw.isEmpty) return '';

    if (_selectedCountry == 'Other') {
      return raw;
    }

    return '$raw\n$_selectedCountry';
  }

  Future<void> _copyToClipboard() async {
    final clean = _buildFormattedAddress();
    if (clean.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: clean));
    HapticFeedback.mediumImpact();

    if (!mounted) return;

    String t(String en, String bn) => tr(widget.language, en, bn);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t('Address copied to clipboard!', 'ঠিকানাটি কপি হয়েছে।'),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearAddress() {
    HapticFeedback.lightImpact();
    _addressController.clear();
    setState(() {});
    _saveValues();
  }

  Future<void> _showCountryPicker() async {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CountryPickerSheet(
        countries: _countries,
        selectedCountry: _selectedCountry,
        isDark: isDark,
        language: widget.language,
      ),
    );

    if (selected != null && selected != _selectedCountry) {
      setState(() => _selectedCountry = selected);
      await _saveValues();
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final horizontalPadding = isWide ? (screenWidth - 600) / 2 : 20.0;

    String t(String en, String bn) => tr(widget.language, en, bn);

    final formattedAddress = _buildFormattedAddress();
    final hasAddress = formattedAddress.isNotEmpty;
    final isFlaggedCountry = _flaggedCountries.contains(_selectedCountry);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF020617)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
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
          t('Address Helper', 'ঠিকানা সহায়ক'),
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
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(
                          'Write your overseas address clearly',
                          'বিদেশের ঠিকানা স্পষ্টভাবে লিখুন',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t(
                          'Use English letters and follow the format asked in the Postal Vote BD app or official form.',
                          'ইংরেজি অক্ষরে ঠিকানা লিখুন এবং Postal Vote BD অ্যাপ বা অফিসিয়াল ফরমে যে ফরম্যাট চাওয়া হয়েছে সেটিই অনুসরণ করুন।',
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (isFlaggedCountry) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.amber.withOpacity(0.12)
                    : Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.amber.withOpacity(0.25)
                      : Colors.amber.shade300,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: isDark
                        ? Colors.amber.shade300
                        : Colors.amber.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t(
                        'Recently, registration in some Gulf countries was paused because many voters did not give a full mailing address. Please write your own complete address with house, street, area, city and postcode so that the ballot can reach you.',
                        'সম্প্রতি কিছু উপসাগরীয় দেশে অনেক ভোটার পূর্ণ ডাক ঠিকানা না দেওয়ায় নিবন্ধন সাময়িকভাবে বন্ধ হয়েছিল। আপনার নিজের সম্পূর্ণ ঠিকানা লিখুন—হাউস, রাস্তা, এলাকা, শহর ও পোস্টকোডসহ—যাতে ব্যালট আপনার কাছে পাঠানো যায়।',
                      ),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: isDark
                            ? Colors.amber.shade200
                            : Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],

          // Country selector
          Text(
            t('Country where you live now', 'আপনি এখন যে দেশে থাকেন'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF334155),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showCountryPicker,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          color: Color(0xFF06B6D4),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedCountry,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.4),
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Address input
          Text(
            t('Your address (in English)', 'আপনার ঠিকানা (ইংরেজিতে)'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF334155),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t('Recommended order: ', 'প্রস্তাবিত ক্রম: ') +
                _formatComponents.join(' → '),
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark
                  ? Colors.white.withOpacity(0.6)
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.08),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    maxLines: 5,
                    onChanged: (_) {
                      setState(() {});
                      _saveValues();
                    },
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'House / Building, Road / Street,\nArea, City, Postcode',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.black.withOpacity(0.3),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                if (_addressController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8),
                    child: IconButton(
                      onPressed: _clearAddress,
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.4),
                        size: 20,
                      ),
                      tooltip: t('Clear', 'মুছে ফেলুন'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Formatted preview
          Text(
            t('Formatted preview', 'ফরম্যাট করা ঠিকানা'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : const Color(0xFF334155),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFF06B6D4).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF06B6D4).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hasAddress
                      ? formattedAddress
                      : t(
                          'Your formatted address will appear here.',
                          'এখানে আপনার ফরম্যাট করা ঠিকানা দেখা যাবে।',
                        ),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: hasAddress
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark
                              ? Colors.white.withOpacity(0.4)
                              : Colors.black.withOpacity(0.4)),
                    fontWeight: hasAddress ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                if (hasAddress) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(t('Copy address', 'ঠিকানা কপি করুন')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Footer note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.blue.shade200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: isDark ? Colors.blue.shade400 : Colors.blue.shade700,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t(
                      'If the instructions in the official Postal Vote BD app or form are different, always follow the official instructions first.',
                      'Postal Vote BD অ্যাপ বা ফরমে দেওয়া নির্দেশনা এই সহায়কের সাথে না মিললে সবসময় অফিসিয়াল নির্দেশনাই আগে অনুসরণ করবেন।',
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark
                          ? Colors.blue.shade200
                          : Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Country picker bottom sheet
class _CountryPickerSheet extends StatefulWidget {
  final List<String> countries;
  final String selectedCountry;
  final bool isDark;
  final AppLanguage language;

  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCountry,
    required this.isDark,
    required this.language,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late TextEditingController _searchController;
  late List<String> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = widget.countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries
            .where(
              (country) => country.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    String t(String en, String bn) => tr(widget.language, en, bn);

    return Container(
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  t('Select country', 'দেশ নির্বাচন করুন'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: widget.isDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCountries,
                style: TextStyle(
                  color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: t(
                    'Search countries...',
                    'দেশের নাম লিখে খুঁজুন...',
                  ),
                  hintStyle: TextStyle(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Country list
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country == widget.selectedCountry;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context, country);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF06B6D4).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF06B6D4),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF06B6D4),
                                size: 22,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              country,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: widget.isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
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
  }
}
