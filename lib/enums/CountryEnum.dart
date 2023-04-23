import 'dart:ui';

enum LanguageDirectionEnum {
  fa,
  en,
  de;

  TextDirection getDirection() {
    return this == LanguageDirectionEnum.fa ? TextDirection.rtl : TextDirection.ltr;
  }

  String getLanguage() {
    switch (this) {
      case fa: return "Farsi";
      case en: return "English";
      case de: return "Deutsch";
    }
  }
}
