import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
            padding: EdgeInsets.only(top:20, left:20, right:20),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: ()async{
                      String email = Uri.encodeComponent("rvamshidhar4@gmail.com");
                      String subject = Uri.encodeComponent("Hello Flutter");
                      String body = Uri.encodeComponent("Hi! I'm Flutter Developer");
                      print(subject); //output: Hello%20Flutter
                      Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                      if (await launchUrl(mail)) {
                        print("Opened");
                      }else{
                        print("Not Opened");//email app is not opened
                      }
                    },
                    child: Text("Mail Us Now")
                )
              ],)
        )
    );
  }
}
