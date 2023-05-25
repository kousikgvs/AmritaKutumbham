import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String AMHARIC = 'am';
const String ARABIC = 'ar';
const String Pashto = 'ps';
const String SPANISH = 'es';
const String FRENCH = 'fr';
const String BURMESE = 'my';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
      break;
    case AMHARIC:
      return const Locale(AMHARIC, "");
      break;
    case ARABIC:
      return const Locale(ARABIC, "");
      break;
    case FRENCH:
      return const Locale(FRENCH, "");
      break;
    case BURMESE:
      return const Locale(BURMESE, "");
      break;
    case SPANISH:
      return const Locale(SPANISH, "");
      break;
    default:
      return const Locale(ENGLISH,'');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}