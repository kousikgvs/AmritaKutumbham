import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seva_map/models/category.dart';
import 'package:seva_map/classes/language_constants.dart';

class Utils{
  static List<Category> getMockedCategories(BuildContext context){
    return [
      Category(
          title:translation(context).water,
          imageName: "1_water.png"
      ),
      Category(
          title: translation(context).education,
          imageName: "2_education.png"
      ),
      Category(
          title:translation(context).latrines,
          imageName: "3_latrines.png"
      ),
      Category(
          title: translation(context).health,
          imageName: "4_health.png"
      ),
      Category(
          title: translation(context).food,
          imageName: "5_food.png"
      ),
      Category(
          title: translation(context).market,
          imageName: "6_market.png"
      ),
      Category(
          title: translation(context).security,
          imageName: "7_security.png"
      ),
      Category(
          title: translation(context).distribution,
          imageName: "8_distribution.png"
      ),
      Category(
          title: translation(context).jobAndSeva,
          imageName: "9_volunteering.png"
      ),
      Category(
          title: translation(context).faith,
          imageName: "10_faith.png"
      ),
      Category(
          title: translation(context).farming,
          imageName: "11_farming.png"
      ),
      Category(
          title: translation(context). leisure,
          imageName: "12_leisure.png"
      )
    ];
  }

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permenantly denied, unable to provide service!');
    }
    return await Geolocator.getCurrentPosition();
  }

}


