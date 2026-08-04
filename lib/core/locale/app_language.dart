enum AppLanguage { bn, en }

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.bn ? 'bn' : 'en';

  String get nativeLabel => this == AppLanguage.bn ? 'বাংলা' : 'English';

  static AppLanguage fromCode(String? code) {
    return code == 'en' ? AppLanguage.en : AppLanguage.bn;
  }
}
