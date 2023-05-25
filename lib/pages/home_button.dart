import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> const App()));
        Navigator.of(context).pushReplacementNamed('/');

      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(207, 23, 76, 1),
          child: const Image(
            image: AssetImage('images/top_menu/home button.png'),
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }
}
