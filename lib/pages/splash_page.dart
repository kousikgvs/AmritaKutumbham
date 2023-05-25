import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget{
  int duration = 0;
  Widget goToPage;

  SplashPage(this.duration, this.goToPage);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>goToPage));
    });
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(44, 219, 229, 1),
        child: const Center(
          child: Image(image:AssetImage('images/icon_map.png'),color: null,),
        ),
      ),
    );

    throw UnimplementedError();
  }

}