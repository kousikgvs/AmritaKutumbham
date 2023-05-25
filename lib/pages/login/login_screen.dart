import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seva_map/auth.dart';
import 'package:seva_map/classes/language_constants.dart';
import 'package:seva_map/data/database_helper.dart';
import 'package:seva_map/models/user.dart';
import 'package:seva_map/pages/login/login_screen_presenter.dart';
import 'package:seva_map/pages/signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/login_check.dart';
import '../../helpers/utils.dart';
import '../add_sevice_event.dart';
import '../forget/forget_password.dart';
import 'package:seva_map/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract {
  late BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username, _password;
  late List services;
  bool login_error = false;

  late LoginScreenPresenter _presenter;

  LinearGradient loginBg = const LinearGradient(
    colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  LoginScreenState() {
    _presenter = LoginScreenPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    var formVal = form?.validate();
    if (formVal ?? false) {
      setState(() => _isLoading = true);
      form?.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    print('from login');
    _ctx = context;
    var loginBtn = SizedBox(
      height: 50.0,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(0)),
        child: Ink(
          decoration: BoxDecoration(
              gradient: loginBg, borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 120.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              translation(context).login,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 18.sp),
            ),
          ),
        ),
        //color: Colors.primaries[0],
      ),
    );
    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
                child: Material(
                  color: Colors.white,
                  child: TextFormField(
                    onSaved: (val) => _username = val!,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid username!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: translation(context).username,
                      icon: const Icon(Icons.email,color: Color(0xFFffa9ca),size: 30),

                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 64),
                child: Material(
                  color: Colors.white,
                  child: TextFormField(
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSaved: (val) => _password = val!,
                    decoration: InputDecoration(
                      labelText: translation(context).password,
                      icon: const Icon(Icons.key,color: Color(0xFFffa9ca),size: 30,),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid password!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        _isLoading ? const CircularProgressIndicator() : loginBtn,
       /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Nunito',
              ),
              child: AutoSizeText(translation(context).password,
                  style: TextStyle(fontSize: 16.0), maxLines: 1),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showForgetPasswordScreen(_ctx);
              },
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Color(0xFFff5b51),
                  fontFamily: 'Nunito',
                ),
                child: AutoSizeText(translation(context).forget,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    maxLines: 1),
              ),
            )
          ],
        ),*/
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Nunito',
              ),
              child: AutoSizeText(translation(context).create_account,
                  style: TextStyle(fontSize: 16.0), maxLines: 1),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showSignUpScreen(_ctx);
              },
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Color(0xFFff5b51),
                  fontFamily: 'Nunito',
                ),
                child: AutoSizeText(translation(context).sign_Up,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    maxLines: 1),
              ),
            )
          ],
        )
      ],
    );

    services = Utils.getMockedCategories(context);
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 64, bottom: 32),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(32, 75),
                bottomLeft: Radius.elliptical(32, 75),
              )),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          //  padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 48.0, top: 32.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Color(0xFFff5b51),
                    fontFamily: 'Nunito',
                  ),
                  child: AutoSizeText(translation(context).welcome_back,
                      style: TextStyle(fontSize: 32.0), maxLines: 2),
                ),
              ),
              loginForm,
            ],
          ),
        ),
      ),
      Positioned(
        left: 7,
        top: 47,
        width: 57,
        height: 57,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(
            'images/add_service/close window.png',
          ),
        ),
      )
    ]);
  }

  Future<Object?> showSignUpScreen(BuildContext context) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const SignUpScreen();
        });
    return dialog;
  }

  Future<Object?> showForgetPasswordScreen(BuildContext context) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return const ForgetPassword();
        });
    return dialog;
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar("Welcome!!!");
    print('id....${user.userid}');
    setState(() => _isLoading = false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', user.userid);
    var db = DatabaseHelper();
    await db.saveUser(user);
    Singleton().isLogin = true;
    var authStateProvider = AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    setState(() {});
  }
}
