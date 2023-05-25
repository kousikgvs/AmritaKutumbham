import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seva_map/pages/service_list_presenter.dart';

import '../helpers/utils.dart';
import 'home_button.dart';
import 'dart:math' as math;

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList>
    implements ServiceListContract {
  late List<Map<String, dynamic>> items = [];
  late List<Map<String, dynamic>> duplicateItems = [];
  late List services;
  late ServiceListPresenter _presenter;
  late double currentLatitude;
  late double currentLongitude;
  bool loading = true;
  TextEditingController editingController = TextEditingController();
  _ServiceListState() {
    _presenter = ServiceListPresenter(this);
    getNearServiceList();
  }
  getNearServiceList() async {
    Utils.getCurrentLocation().then((value){
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;
      _presenter.doGetNearServiceList(currentLatitude.toString(), currentLongitude.toString());
    });

  }
  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item["title"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    services = Utils.getMockedCategories(context);
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFff5b51),
            ),
          )
        : Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const HomeButton(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, top: 8, bottom: 8),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              items.length == 0
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No service available here!",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          color: Color(0xFFff5b51),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final iconIndex = items[index]["categoryId"];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/categories/${services[iconIndex - 1].imageName}',
                                ),
                                title: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: Offset(0, 1.5),
                                            blurStyle: BlurStyle.normal),
                                      ],
                                      color: Color(0xFF00b8c3),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          items[index]["title"],
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Nunito',
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' ${items[index]['distance']} km',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          color: Colors.black45,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
            ],
          );
  }

  @override
  void onServiceListError(String errorTxt) {
    print("on error service $errorTxt");
    setState(() {
      loading = false;
    });
  }

  @override
  void onServiceListSuccess(List serviceList) {
    print("on success service $serviceList");
    for (int i = 0; i < serviceList.length; i++) {
      var service = serviceList[i];
      var latitude = double.parse(service['latitude']);
      var longitude = double.parse(service['longitude']);
      var distanceKM = getDistanceFromLatLonInKm(currentLatitude,currentLongitude,latitude,longitude);
      Map<String, dynamic> map = {
        "title": service["title"],
        "categoryId": service["category_id"],
        "distance": distanceKM
      };
      duplicateItems.add(map);
    }
    selectionSort(duplicateItems);
    items = duplicateItems;
    setState(() {
      loading = false;
    });
  }

  void selectionSort(List list) {
    if (list.isEmpty) return;
    int n = list.length;
    int i, steps;
    for (steps = 0; steps < n; steps++) {
      for (i = steps + 1; i < n; i++) {
        if(double.parse(list[steps]['distance']) > double.parse(list[i]['distance'])) {
          swap(list, steps, i);
        }
      }
    }
  }

  void swap(List list, int steps, int i) {
    var temp = list[steps];
    list[steps] = list[i];
    list[i] = temp;
  }

  getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d.toStringAsFixed(1);
  }

  deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
