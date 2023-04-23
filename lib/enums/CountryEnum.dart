import 'dart:ui';

enum LanguageDirectionEnum {
  fa,
  en,
  de;

  TextDirection getDirection() {
    return this == LanguageDirectionEnum.fa ? TextDirection.rtl : TextDirection.ltr;
  }
}
