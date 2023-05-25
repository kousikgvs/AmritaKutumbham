import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seva_map/pages/signup/signup_screen_presenter.dart';

import '../../classes/language_constants.dart';
import '../../helpers/utils.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements SignUpScreenContract{
  late BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String email, _password;
  late List services;
  late SignUpScreenPresenter   _presenter;
  late String confirmPassword, countryCode, phone,contactName,orgName,status,role;
  final _status = "A";
  final _role = "2";
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  LinearGradient loginBg = const LinearGradient(
    colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  _SignUpScreenState(){
    _presenter = SignUpScreenPresenter(this);
  }
  void _submit() {
    print("signu[");
    final form = formKey.currentState;
    var formVal = form?.validate();
    if (formVal ?? false) {
      setState(() => _isLoading = true);
      form?.save();
       _presenter.doSignUp(email, _password,countryCode,phone,orgName,contactName,_role,_status);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),));
  }

  @override
  Widget build(BuildContext context) {
    print('from login');
    _ctx = context;
    var signUpBtn = SizedBox(
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
            child:  Text(
              translation(context).sign_Up,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 18),
            ),
          ),
        ),
        //color: Colors.primaries[0],
      ),
    );

    services = Utils.getMockedCategories(context);
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 64, bottom: 32),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(32, 32),
                bottomLeft: Radius.elliptical(32, 32),
              )),
          width: MediaQuery.of(context).size.width,
          height: 550,//MediaQuery.of(context).size.height - 80,
          //  padding: EdgeInsets.all(20),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: EdgeInsets.only(top: 32.0,left: 26),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Color(0xFFff5b51),
                      fontFamily: 'Nunito',
                    ),
                    child: AutoSizeText(translation(context).create_account,
                        style: TextStyle(fontSize: 30.0), maxLines: 2),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              color: Colors.white,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (val) => email = val!,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Enter a valid username!';
                                  }
                                  return null;
                                },
                                decoration:
                                  InputDecoration(labelText: translation(context).email),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: TextFormField(
                                controller: _pass,
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                onSaved: (val) => _password = val!,
                                validator: (value) {
                                  RegExp regex =
                                  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (value!.isEmpty || !regex.hasMatch(value)) {
                                    return 'Should contain 1 Upper Case,1 Lower Case,\n1 Digit,1 Special Character';
                                  }
                                  return null;
                                },
                                decoration:
                                     InputDecoration(labelText: translation(context).password),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: TextFormField(
                                controller: _confirmPass,
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                onSaved: (val) => confirmPassword = val!,
                                validator: (val){
                                if(val!.isEmpty) {
                                  return 'Empty';
                                }
                                if(val != _pass.text) {
                                  return 'Password Not Matching!';
                                }
                                return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Confirm Password"),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Material(
                                    color: Colors.white,
                                    child: TextFormField(
                                      //  controller: countryCodeController,
                                      keyboardType: TextInputType.phone,
                                      decoration:  InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text(translation(context).country_code)),
                                      onSaved: (val) => countryCode = val!,
                                      validator: (val) {
                                        if (val == null || val.isEmpty || !RegExp(r"^[+-0-9()]")
                                            .hasMatch(val) ) {
                                          return 'Enter a valid Country code!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Material(
                                    color: Colors.white,
                                    child: TextFormField(
                                      //  controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: Text(translation(context).phonenumber)),
                                      onSaved: (val) => phone = val!.trim(),
                                      validator: (val) {
                                        int n= val!.length;
                                        if (val == null || val.isEmpty) {
                                          return translation(context).phone_number_is_mandatory;

                                        }
                                        if (!RegExp(r"^[0-9]")
                                            .hasMatch(val) || n != 10){
                                          return 'Enter a valid Phone number!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Material(
                              color: Colors.white,
                              child: TextFormField(

                                autocorrect: false,
                                enableSuggestions: false,
                                onSaved: (val) => orgName = val!,
                                validator: (val){
                                  if(!RegExp(r"^\s*([A-Za-z]{1,})")
                                      .hasMatch(val!)){
                                      return 'Enter Valid Organization Name';
                                  }
                                },
                                decoration:  InputDecoration(
                                    labelText: translation(context).organization_name),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              child: TextFormField(

                                autocorrect: false,
                                enableSuggestions: false,
                                onSaved: (val) => contactName = val!,
                                validator: (val){
                                  if(!RegExp(r'^[a-zA-Z 0-9@]+$')

                                  .hasMatch(val!)){
                                    return 'Enter a valid Name';
                                  }
                                },
                                decoration:  InputDecoration(
                                    labelText:translation(context).key_Contact_Person),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : signUpBtn,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: translation(context).back_to,
                                  ),
                                  child: AutoSizeText("Back to",
                                      style: TextStyle(fontSize: 16.0),
                                      maxLines: 1),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showLoginScreen(_ctx);
                                  },
                                  child: const DefaultTextStyle(
                                    style: TextStyle(
                                      color: Color(0xFFff5b51),
                                      fontFamily: 'Nunito',
                                    ),
                                    child: AutoSizeText("Login",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
  Future<Object?> showLoginScreen(BuildContext context) async {

    var dialog =  await showGeneralDialog(
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

  @override
  void onSignUpError(String errorTxt) {
    print('form signup error$errorTxt');
    setState(() {
      _isLoading = false;
    });
    _showSnackBar("Sorry Unable to create an account now!");
    Navigator.of(context).pop();
  }

  @override
  void onSignUpSuccess(response) {
    // TODO: implement onSignUpSuccess
    print('form onSignUpSuccess $response');
    setState(() {
      _isLoading = false;
    });
    _showSnackBar(response['message']);
    Navigator.of(context).pop();
  }
}
