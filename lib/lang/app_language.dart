enum AppLanguage { en, bn }


String tr(AppLanguage lang, String en, String bn) {
return lang == AppLanguage.bn ? bn : en;
}


String languageShortLabel(AppLanguage lang) {
return lang == AppLanguage.bn ? 'BN' : 'EN';
}


String languageFullLabel(AppLanguage lang) {
return lang == AppLanguage.bn ? 'বাংলা' : 'English';
}