import 'dart:async';
import 'dart:convert';

import 'package:seva_map/helpers//network_util.dart';
import 'package:seva_map/models/user.dart';

class RestDatasource {
  final NetworkUtil _netUtil = NetworkUtil();
  static const baseUrl = "http://sevamap.amritacreate.org";
  static const apiKey = "somerandomkey";
  static const loginUrl = "$baseUrl/login";
  static const addServiceUrl = "$baseUrl/service";
  static const addEventUrl = "$baseUrl/events";
  static const getNearServiceListUrl = "$baseUrl/servicenear";
  static const getNearEventListUrl = "$baseUrl/eventsnear";
  static const signUpUrl = "$baseUrl/signup";
  static const myEventsUpUrl = "$baseUrl/myevents/";


  Future<User> login(String username, String password) {
    print('result from server...1');
    return _netUtil.post(loginUrl, body: jsonEncode(<String, String>{
      "email" : username,
      "pswd":password

    } ) ).then((dynamic res) {
      print('result from server..2');
      print(res.toString());
      print(res["user"]['username']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return User.map(res["user"]);
    });
  }
  Future<String> addService(String categoryId,String title, String shortDescription,String detailedDescription, String countryCode,String phone,String email,String latitude,String longitude,String createdBy ) {
    print('From Add Sevice');
    return _netUtil.post(addServiceUrl, body: jsonEncode(<String, String>{
      "category_id": categoryId,
      "title": title,
      "short_desc":shortDescription,
      "detailed_desc": detailedDescription,
      "country_code": countryCode,
      "phone": phone,
      "email": email,
      "latitude": latitude,
      "longitude": longitude,
      "created_by": createdBy

    } ) ).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res["serviceId"].toString();
    });
  }

  Future<String> addEvent(String title, String subTitle,String startDate, String endDate,String startTime,String endTime,String countryCode,String phone,String email,String orgName,String latitude,String longitude,String createdBy,String status ) {
    print('From Add Sevice');
    return _netUtil.post(addEventUrl, body: jsonEncode(<String, String>{
      "title": title,
      "sub_title":subTitle,
      "start_date": startDate,
      "end_date": endDate,
      "start_time": startTime,
      "end_time": endTime,
      "country_code": countryCode,
      "phone": phone,
      "email": email,
      "org_name": orgName,
      "latitude": latitude,
      "longitude": longitude,
      "created_by": createdBy,
      "event_status": status

    } ) ).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res["eventId"].toString();
    });
  }

  Future<List> getNearServiceList(String latitude, String longitude ) {
    print('From getServiceList');
    return _netUtil.post(getNearServiceListUrl, body: jsonEncode(<String, String>{
      "latitude": latitude,
      "longitude": longitude,

    } ) ).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res["serviceList"];
    });
  }
// Function to get nearest event list
  Future<List> getNearEventList(String latitude, String longitude ) {
    print('From getServiceList');
    return _netUtil.post(getNearEventListUrl, body: jsonEncode(<String, String>{
      "latitude": latitude,
      "longitude": longitude,

    } ) ).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res["events"];
    });
  }

  Future<dynamic> signUp(String email, String password,String countryCode,String phone,String orgName,String contactPerson,String role,String status){
    print('From signUp');
    return _netUtil.post(signUpUrl, body: jsonEncode(<String, String>{
      "email": email,
      "pswd": password,
      "country_code": countryCode,
      "phone": phone,
      "org_name": orgName,
      "contact_name":contactPerson,
      "role": role,
      "status": status

    } ) ).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res;
    });
  }

/* To get all events created by current user */
  Future<dynamic> myEvents(String createdBy){
    print('From myEvents');
    return _netUtil.get(myEventsUpUrl+createdBy).then((dynamic res) {
      print(res.toString());
      print(res['message']);
      if(res["error"]) throw Exception(res["error_msg"]);
      return res;
    });
  }
}