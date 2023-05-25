import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seva_map/pages/splash_page.dart';
import 'package:seva_map/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seva_map/classes/language_constants.dart';

import 'data/database_helper.dart';
import 'package:seva_map/globals.dart' as globals;
void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
  static void setLocale(BuildContext context,Locale newLocale){
    _AppState? state=context.findAncestorStateOfType<_AppState>();
    state?.setLocale(newLocale);
  }

}

class _AppState extends State<App> {
  Locale?_locale;
  setLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:(context,child){
        return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(title: 'Amrita Kutumbakam'),
            },
          debugShowCheckedModeBanner: false,
          title: 'Amrita Kutumbakam',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,// added delegates for all widgets to support multi-language

          locale:_locale,
         // home:child
        );
      },
      child:const HomePage(title: 'Amrita Kutumbakam'),
    );
  }
}
