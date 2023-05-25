import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seva_map/helpers/utils.dart';

class ServiceHome extends StatefulWidget {
  const ServiceHome({Key? key}) : super(key: key);

  @override
  State<ServiceHome> createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> {

  @override
  Widget build(BuildContext context) {
    List categories = Utils.getMockedCategories(context);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Container(
              padding: EdgeInsets.all(5),
              color: Color.fromRGBO(207, 23, 76, 1),
              child: const Image(
                image: AssetImage('images/top_menu/sound off.png'),
                width: 50,
                height: 50,
              ),
            ),
          ),
          SizedBox(height: 16,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(categories.length, (index) {
                return InkWell(
                  onTap: (){
                    print('tapedd@@');
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
}