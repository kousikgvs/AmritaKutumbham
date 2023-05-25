import 'package:flutter/material.dart';
import 'package:seva_map/main.dart';
import 'package:seva_map/pages/calendar.dart';
import 'package:seva_map/pages/profile/profile_screen.dart';
import 'package:seva_map/pages/service_list.dart';
import 'package:seva_map/pages/service_map.dart';
import 'package:seva_map/pages/servie_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/database_helper.dart';
import '../helpers/utils.dart';
import 'add_sevice_event.dart';
import 'contact_us.dart';
import 'package:seva_map/classes/language_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login/login_screen.dart';
import 'package:seva_map/globals.dart' as globals;
import 'package:seva_map/helpers/login_check.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _homeIndex = 0;
  bool _home = true;
  late TabController _tabController;
  late double currentLatitude;
  late double currentLongitude;
  final double windowBaseHeight = 680.0;
  late double heightDifference;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    Utils.getCurrentLocation().then((value) {
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;
    });
    loginChecking();
    print("))))))");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<dynamic> _widgetOptions = <dynamic>[
    Center(
      child: Text(
        'Language',
        style: optionStyle,
      ),
    ),
    ServiceMap(),
    ServiceList(),
    LoginScreen(),
    CalendarView(),
  ];
/*  contactUs() async {
    String email = Uri.encodeComponent("amritacreate@gmail.com");
    String subject = Uri.encodeComponent("Seva Map");
    String body = Uri.encodeComponent("Your queries!!");
    print(subject); //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
    } else {
      print("Not Opened"); //email app is not opened
    }
  }*/

  Future<bool> loginCheck() async {
    var db = DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    print(';;;;;;;;;;;;;;;$isLoggedIn');
    if (isLoggedIn) {
      return true;
    }
    return false;
  }

  void _onItemTapped(int index) async {
    switch (index) {
      case 0:
        const String ENGLISH = 'en';
        const String AMHARIC = 'am';
        const String ARABIC = 'ar';
        const String Pashto = 'ps';
        const String SPANISH = 'es';
        const String FRENCH = 'fr';
        const String BURMESE = 'my';
        final String appLocale = Localizations.localeOf(context).toString();
        print(")))))----)$appLocale");
        switch (appLocale) {
          case ENGLISH:
            Singleton().selectedLanguage = "English";
            break;
          case AMHARIC:
            Singleton().selectedLanguage = "Amharic";
            break;
          case ARABIC:
            Singleton().selectedLanguage = "Arabic";
            break;
          case FRENCH:
            Singleton().selectedLanguage = "French";
            break;
          case BURMESE:
            Singleton().selectedLanguage = "Burmese";
            break;
          case SPANISH:
            Singleton().selectedLanguage = "Spanish";
            break;
          default:
            Singleton().selectedLanguage = "English";
        }
        // only scroll to top when current index is selected.
        showModal(context);
        break;
      case 1:
        // only scroll to top when current index is selected.
        print(_homeIndex);

        break;
      case 3:
        // only scroll to top when current index is selected.
        await loginCheck()
            ? showServiceEventDialog(context)
            : showLoginScreen(context);
        //  false ? showServiceEventDialog(context) :showLoginScreen(context);
        //  LoginScreen();
        break;
    }
    setState(() {
      if (index != 0 && index != 3) {
        // && index != 2
        _selectedIndex = index;
        _home = false;
      }
     /* if (index == 1) {
        if (_homeIndex == 1) {
          _homeIndex = 0;
        } else {
          _homeIndex = 1;
        }
        print('-------$_homeIndex');
      }
      if (index == 4) {
        contactUs();
      }*/
    });
  }

  Future<Object?> showServiceEventDialog(BuildContext context) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const AddServiceAndEvent();
        });
    return dialog;
  }

  Future<Object?> showLoginScreen(BuildContext context) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const LoginScreen();
        });
    return dialog;
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(translation(context).select_language),
            DropdownButton<String>(
              hint: Text(Singleton().selectedLanguage),
              items: <String>[
                'English',
                'العربية',
                'አማርኛ',
                'ဗမာစာ',
                'Français',
                'Español'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? language) async {
                print(language);

                Locale _locale = await setLocale("en");
                if (language == 'English') {
                  _locale = await setLocale("en");
                  print('English language selected');
                } else if (language == 'العربية') {
                  _locale = await setLocale("ar");
                  print('Arabic language selected');
                } else if (language == 'ဗမာစာ') {
                  _locale = await setLocale("my");
                  print('Burmese language selected');
                } else if (language == 'አማርኛ') {
                  _locale = await setLocale("am");
                  print('Amharic language selected');
                } else if (language == 'Français') {
                  _locale = await setLocale("fr");
                  print('French language selected');
                } else if (language == 'Kurdish') {
                  _locale = await setLocale(
                      "en"); //currently there is no code to translate for this so I have set to english
                  print('Kurdish language selected');
                } else if (language == 'Español') {
                  _locale = await setLocale("es");
                  print('Spanish language selected');
                }
                print("........." + language!);
                setState(() {
                  Singleton().selectedLanguage = language.toString();
                });
                App.setLocale(context, _locale);
              },
            )
          ],
        ),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(translation(context).close),
          )
        ],
      ),
    );
  }

  BottomNavigationBarItem navBarItem({icon, activeIcon}) {
    const double iconWidth = 50;
    return BottomNavigationBarItem(
      icon: Image(
        image: AssetImage(icon),
        width: iconWidth,
        height: iconWidth,
      ),
      activeIcon: Image(
        image: AssetImage(activeIcon),
        width: iconWidth,
        height: iconWidth,
      ),
      label: '',
    );
  }

  loginChecking() async {
    print('fomr main init');
    var db = DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn) {
      setState(() {
        globals.isLoggedIn = true;
        Singleton().isLogin = true;
      });
      print('fomr main init isLoggedIn//${globals.isLoggedIn}');
    }
    globals.isLoggedIn = false;
  }

  serviceHome() {
    List categories = Utils.getMockedCategories(context);
    int divFactor = Singleton().isLogin ? 5 : 3;
    print('Singleton.....XXX ${Singleton().isLogin}');
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Singleton().isLogin
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0,
                      child: InkWell(
                        onTap: () {},
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: Color(0xFFff5b51),
                            child: const Image(
                              image:
                                  AssetImage('images/top_menu/sound off.png'),
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Taped");
                        showProfile(context);
                      },
                      child: ClipOval(
                        child: Container(
                          //   padding: EdgeInsets.all(5),
                          //  color: Color.fromRGBO(207, 23, 76, 1),
                          child: const Image(
                            image:
                                AssetImage('images/top_menu/icon-profile.png'),
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: heightDifference > 0
                  ? heightDifference / divFactor
                  : (Singleton().isLogin ? 0 : 12),
              children: List.generate(categories.length, (index) {
                return InkWell(
                  onTap: () {
                    print(MediaQuery.of(context).size.height);
                    _onItemTapped(1);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          '${'images/categories/' + categories[index].imageName}',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Text(
                        categories[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Future<Object?> showProfile(BuildContext context) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const ProfileScreen();
        });
    return dialog;
  }

  @override
  Widget build(BuildContext context) {
    heightDifference = MediaQuery.of(context).size.height - windowBaseHeight;
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(10, 228, 235, 1),
          body: _home
              ? serviceHome()
              : _widgetOptions[
                  _selectedIndex], // This trailing comma makes auto-formatting nicer for build methods.
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              gradient:  LinearGradient(
                colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                stops: [0.0, 0.8],
                tileMode: TileMode.clamp,
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 25,
              unselectedFontSize: 16,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              unselectedItemColor: Colors.white,
              selectedIconTheme: const IconThemeData(color: Colors.white),
              items: <BottomNavigationBarItem>[
                navBarItem(
                    icon: 'images/bottom_menu/icon-language.png',
                    activeIcon: 'images/bottom_menu/icon-language.png'),
                navBarItem(
                    icon: 'images/bottom_menu/icon-map.png',
                    activeIcon: 'images/bottom_menu/icon-map-selected.png'),
                navBarItem(
                    icon: 'images/bottom_menu/icon-list.png',
                    activeIcon: 'images/bottom_menu/icon-list-selected.png'),
                /*  BottomNavigationBarItem(
                  icon: Image(
                    image: iconList[_homeIndex],
                    width: iconWidth,
                    height: iconWidth,
                  ),
                  activeIcon: Image(
                    image: activeIconList[_homeIndex],
                    width: iconWidth,
                    height: iconWidth,
                  ),
                  label: '',
                ),*/
                navBarItem(
                  icon: 'images/bottom_menu/icon-add-one.png',
                  activeIcon: 'images/bottom_menu/icon-add-one-selected.png',
                ),
                navBarItem(
                    icon: 'images/bottom_menu/icon-calendar.png',
                    activeIcon: 'images/bottom_menu/icon-calendar-selected.png'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
