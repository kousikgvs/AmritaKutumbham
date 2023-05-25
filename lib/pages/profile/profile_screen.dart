import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seva_map/pages/profile/profile_events_presenter.dart';

import '../../classes/language_constants.dart';
import 'package:seva_map/globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    implements ProfileEventsContract {
  final formKey = GlobalKey<FormState>();
  LinearGradient selectedButtonBg = const LinearGradient(
    colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient buttonBg = const LinearGradient(
    colors: [Color(0xFF5bdde6), Color(0xFF5bdde6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  bool eventSelected = true;
  late String _password;
  late ProfileEventsPresenter _presenter;
  late String userId;
  bool eventLoading = true;
  List<dynamic> eventList = [];
  List<dynamic> serviceList = [];
  LinearGradient loginBg = const LinearGradient(
    colors: [Color(0xFFff5b51), Color(0xFFff5c91)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  _ProfileScreenState() {
    _presenter = ProfileEventsPresenter(this);
  }

  void _submit() {
    print("signu[");
    final form = formKey.currentState;
    var formVal = form?.validate();
    if (formVal ?? false) {
      // setState(() => _isLoading = true);
      form?.save();
      //  _presenter.doSignUp(email, _password,countryCode,phone,orgName,contactName,_role,_status);
    }
  }

  @override
  void initState() {
    super.initState();
    print('user id${globals.userId}');
    userId = globals.userId;
    _presenter.doMyEvents(userId);
  }

  @override
  Widget build(BuildContext context) {
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
          height: MediaQuery.of(context).size.height - 80,
          //  padding: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('images/top_menu/icon-profile.png'),
                    width: 140,
                    height: 140,
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        color: Color(0xFFff5b51),
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 24.sp),
                    child: Text(translation(context).my_profile,),
                  ),
                  Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Material(
                            child: TextFormField(
                              onSaved: (val) => _password = val!,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return 'Enter a valid password!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: translation(context).password),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 37.0,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                padding: const EdgeInsets.all(0)),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: loginBg,
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Container(
                                constraints: const BoxConstraints(
                                    maxWidth: 110.0, minHeight: 37.0),
                                alignment: Alignment.center,
                                child: Text(
                                  translation(context).change,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            //color: Colors.primaries[0],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              eventSelected = true;
                            });
                            print(eventSelected);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              padding: const EdgeInsets.all(0)),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: eventSelected
                                    ? selectedButtonBg
                                    : buttonBg,
                                borderRadius:
                                BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 120.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                translation(context).my_service,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 18.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              eventSelected = false;
                            });
                            print(eventSelected);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              padding: const EdgeInsets.all(0)),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: eventSelected
                                    ? buttonBg
                                    : selectedButtonBg,
                                borderRadius:
                                BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 120.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                translation(context).my_event,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  eventLoading
                      ? Padding(padding:EdgeInsets.only(top: 60,),child: const Center(child: CircularProgressIndicator()))
                      : eventSelected ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: serviceList!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: DefaultTextStyle(
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20.sp,
                                          ),
                                          child: Text(serviceList[index]
                                                  ["title"] ??
                                              "got null")),
                                    ),
                                    Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color(0xFFff5c91),
                                          size: 30,
                                        ),
                                        onTap: () {
                                          print("taped");
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color(0xFFff5c91),
                                          size: 30,
                                        ),
                                        onTap: () {
                                          print("hii...tap");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 8,
                                ),
                              ],
                            );
                          },
                        ) : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventList!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.sp,
                                    ),
                                    child: Text(eventList[index]
                                    ["title"] ??
                                        "got null")),
                              ),
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xFFff5c91),
                                    size: 30,
                                  ),
                                  onTap: () {
                                    print("taped");
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  child: const Icon(
                                    Icons.delete,
                                    color: Color(0xFFff5c91),
                                    size: 30,
                                  ),
                                  onTap: () {
                                    print("hii...tap");
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 8,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
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

  @override
  void onProfileEventsError(String errorTxt) {
    print("profile error $errorTxt");
  }

  @override
  void onProfileEventsSuccess(response) {
    print("profile success $response");
    setState(() {
      eventLoading = false;
      eventList.addAll(response['events']);
      serviceList.addAll(response['service']);
    });
  }
}
