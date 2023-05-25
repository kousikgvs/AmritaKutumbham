import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import '../login/login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late String email, _password;
  late EmailAuth emailAuth;
  final TextEditingController _emailController = TextEditingController();

  LinearGradient loginBg = const LinearGradient(
    colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );


  void _submit() {
    final form = formKey.currentState;
    var formVal = form?.validate();
    if (formVal ?? false) {
      setState(() => _isLoading = true);
      form?.save();
    //  _presenter.doLogin(_username, _password);
    }
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.value.text, otpLength: 5
    );
    print(result);
  }

  _ForgetPasswordState(){

  }
  @override
  void initState() {
    emailAuth =  EmailAuth(sessionName: "Sample session");
    emailAuth.config( {
    "server": "server url",
    "serverKey": "serverKey"
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('from login');
    _ctx = context;
    var sendBtn = SizedBox(
      height: 50.0,
      child: ElevatedButton(
        onPressed: sendOtp,
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
            child: const Text(
              "Send",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 18),
            ),
          ),
        ),
        //color: Colors.primaries[0],
      ),
    );

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
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 64.0,left: 26),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Color(0xFFff5b51),
                      fontFamily: 'Nunito',
                    ),
                    child: AutoSizeText("Password \nreset",
                        style: TextStyle(fontSize: 30.0), maxLines: 2),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              child: TextFormField(
                                controller: _emailController,
                                onSaved: (val) => email = val!,
                                validator: (val) {
                                  int len = val!.length;
                                  return len < 10
                                      ? "Username must have atleast 10 chars"
                                      : null;
                                },
                                decoration:
                                const InputDecoration(prefixIcon: Icon(Icons.email,color: Color(0xFFffa7a6),),labelText: "Email"),
                              ),
                            ),
                            const SizedBox(height: 32,),
                            sendBtn,
                            const SizedBox(height: 32,),
                            const DefaultTextStyle(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black45,
                                fontFamily: 'Nunito',
                              ),
                              child: AutoSizeText("You will receive OTP for setting your password",
                                  style: TextStyle(fontSize: 16.0), maxLines: 2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'Nunito',
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
}

