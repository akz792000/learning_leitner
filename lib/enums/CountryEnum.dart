import 'dart:ui';

enum LanguageEnum {
  fa,
  en,
  de;

  TextDirection getDirection() {
    return this == LanguageEnum.fa ? TextDirection.rtl : TextDirection.ltr;
  }

  String getLanguage() {
    switch (this) {
      case fa: return "Farsi";
      case en: return "English";
      case de: return "Deutsch";
    }
  }
}
