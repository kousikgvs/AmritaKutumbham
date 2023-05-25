class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();

  bool isLogin = false;
  String selectedLanguage = "English";
}