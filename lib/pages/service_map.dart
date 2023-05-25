import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:seva_map/pages/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:seva_map/pages/service_list_presenter.dart';

import '../helpers/utils.dart';
import 'home_button.dart';

class ServiceMap extends StatefulWidget {
  const ServiceMap({Key? key}) : super(key: key);

  @override
  State<ServiceMap> createState() => _ServiceMapState();
}

class _ServiceMapState extends State<ServiceMap>
    implements ServiceListContract {
  final Completer<GoogleMapController> _controller = Completer();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  List<Marker> _marker = [];

  List<LatLng> polylineCoordinates = [];
  late ServiceListPresenter _presenter;
  late double currentLatitude;
  late double currentLongitude;
  late double destinationLatitude;
  late double destinationLongitude;
  late List<Map<String, dynamic>> serviceList = [];
  late List servicesIconList;
  late BuildContext _context;
  bool loading = true;

  TextEditingController searchController = TextEditingController();
  _ServiceMapState() {
    _presenter = ServiceListPresenter(this);
    getNearServiceList();
  }
  getNearServiceList() async {
    Utils.getCurrentLocation().then((value) {
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;
      _presenter.doGetNearServiceList(
          currentLatitude.toString(), currentLongitude.toString());
    });
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final List<LatLng> _latlng = <LatLng>[
    //  Kerala Lat Long
    LatLng(9.104750, 76.495640),
    LatLng(9.113990, 76.473717),
    LatLng(9.088483, 76.49315),
    LatLng(9.108710, 76.496070),

    // For Guntur
    // LatLng(16.320150, 80.418310),
    // LatLng(16.304650, 80.430580),
    // LatLng(16.298470, 80.425070),
    // LatLng(16.324460, 80.421670),
  ];

// ------------------------------------------------------------------------------------------------------\
// ------------------------------------------------------------------------------------------------------\
//  This code snippet is to get Current Location of The User and Adding a marker into the Map
  loadData() async {
    print("---------------------------------------------------");

    CameraPosition cameraPosition = CameraPosition(
      zoom: 15,
      target: LatLng(currentLatitude, currentLongitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    setState(() {});
  }

  animateGoogleMap(LatLng data) async {
    print("---------------------------------------------------");

    CameraPosition cameraPosition = CameraPosition(
      zoom: 15,
      target: LatLng(data.latitude, data.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    setState(() {});
  }

// ------------------------------------------------------------------------------------------------------\
// --------------------------------------------------------------------------------------------------\

  // This is the Code for adding the Custom Marker
  addacustommarker(Map<String, dynamic> service) {
    var detailedTextArray = service["detailedDescription"].split(".");
    var detailedText = '';
    // Adding suggestions to Text Fields
    for (int i = 0; i < detailedTextArray.length; i++) {
      if (i == detailedTextArray.length - 1) {
        detailedText += detailedTextArray[i].trim() + '.';
      } else {
        detailedText += detailedTextArray[i].trim() + '.\n';
      }
    }
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 204, bottom: 32),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(32, 32),
                bottomLeft: Radius.elliptical(32, 32),
              )),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 300,
          //  padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 22.0, top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(
                          color: const Color(0xFF000000),
                          fontSize: 24.sp,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900),
                      child: Text(
                        service["title"],

                        maxLines: 2,
                        //  overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),

                    // Here is the content for Padding
                    SizedBox(
                      height: 8.0,
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Nunito',
                      ),
                      child: Text(
                        service["shortDescription"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                        ),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Nunito',
                        fontSize: 16,
                      ),
                      child: Text(
                        detailedText,
                      ),
                    ),

                    //  Here are the 3 Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                getPolylines(service["latLnt"].latitude,
                                    service["latLnt"].longitude);

                                Navigator.of(context).pop();
                              },
                              child: Column(
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        "images/selected_service/directions.png"),
                                  ),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                        color: const Color(0xFFff5b51),
                                        fontFamily: 'Nunito',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                    child: const Text(
                                      "Direction",
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                polylineCoordinates = <LatLng>[];
                                polylineCoordinates.add(service["latLnt"]);
                                print("clicked");

                                // Function For Making Phone Calls
                                _makingPhoneCall(service["phone"]);
                              },
                              child: Column(
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        "images/selected_service/phone.png"),
                                  ),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                        color: const Color(0xFFff5b51),
                                        fontFamily: 'Nunito',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                    child: const Text(
                                      "Phone",
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                polylineCoordinates = <LatLng>[];
                                polylineCoordinates.add(service["latLnt"]);
                                print("clicked");

                                shareApp(service["title"], service["latLnt"]);
                              },
                              child: Column(
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        "images/selected_service/share.png"),
                                  ),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                        color: const Color(0xFFff5b51),
                                        fontFamily: 'Nunito',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                    child: const Text(
                                      "Share",
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //service["latLnt"],
            ],
          ),
        ),
      ),
      Positioned(
        left: 70,
        top: 90,
        child: Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(service["imgUrl"]),
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.red,
          ),
        ),
      ),
      Positioned(
        left: 7,
        top: 187,
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

//--------------------------------------------------------------------------------------------------------\

  void getPolylines(double destLatitude, double destLongitude) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(currentLatitude, currentLongitude),
      PointLatLng(destLatitude, destLongitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          ));
      setState(() {});
    }
  }

// ------------------------------------------------------------------------------------------------------\
// ----------------------------------------------------------------------------------------------------\
// This Code snippet is to add all the markers into the Map
  loaAllData() async {
    print("I am in Load data");
    print("------------------------------------------");
    print(_latlng);
    print("-------------------------------------------");
    final Uint8List currentLocationIcon =
        await getImages("images/icon_map.png", 200);

    _marker.add(
      Marker(
        markerId: const MarkerId("0"),
        icon: BitmapDescriptor.fromBytes(currentLocationIcon),
        position: LatLng(currentLatitude, currentLongitude),
        infoWindow: const InfoWindow(
          title: "My Current User Location",
        ),
      ),
    );
    for (int i = 0; i < serviceList.length; i++) {
      Map<String, dynamic> service = serviceList[i];

      // making all titles of google map into suggestions array
      _suggetions.add(service["title"]);
      suggestionMap[service["title"]] = service["latLnt"];

      int markerId = i + 1;
      final Uint8List markIcons = await getImages(service["serviceIcon"], 180);
      _marker.add(
        Marker(
          markerId: MarkerId(markerId.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: service["latLnt"],
          onTap: () {
            showLoginScreen(_context, service);
          },
        ),
      );
    }
    loadData();
    // getPolylines(9.088483, 76.49315);
  }

  _makingPhoneCall(int number) async {
    var url = Uri.parse('tel:${number}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  shareApp(String servicename, LatLng locationservice) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${locationservice.latitude},${locationservice.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      Share.share(
          'Check This Place ${servicename} \n Geolocation of the service ${locationservice.latitude}  ${locationservice.longitude} \n ${url}');
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareGoogleMapsLocation(double latitude, double longitude) async {}

  Future<Object?> showLoginScreen(
      BuildContext context, Map<String, dynamic> service) async {
    var dialog = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return addacustommarker(service);
          ;
        });
    return dialog;
  }

  @override
  void initState() {
    super.initState();
    // setCustomMarkerIcon();
  }

  String searchValue = '';
  final List<String> _suggetions = [];
  Map<String, LatLng> suggestionMap = {'': LatLng(0, 0)};
  @override
  Widget build(BuildContext context) {
    servicesIconList = Utils.getMockedCategories(context);
    _context = context;

    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFff5b51),
            ),
          )
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLatitude, currentLongitude),
                  zoom: 14,
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.blue,
                    width: 6,
                  )
                },
                markers: Set<Marker>.of(_marker),
                padding: const EdgeInsets.only(top: 200, left: 10),
                zoomControlsEnabled: true,
                onTap: (position) {
                  print('taped');
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                onMapCreated: (GoogleMapController controller) {
                  _customInfoWindowController.googleMapController = controller;
                  _controller.complete(controller);
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 600,
                width: 500,
                offset: 15,
              ),
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
                        child: Container(
                          height: 45,
                          child: EasySearchBar(
                            title: const Text('Search for a Place'),
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            elevation: 10,
                            onSearch: (value) =>
                                setState(() => searchValue = value),
                            suggestions: _suggetions,
                            onSuggestionTap: (data) {
                              print("????????????????????????????????");
                              print("TheData is " + data);
                              print(suggestionMap[data]);
                              animateGoogleMap(suggestionMap[data]!);
                              print("????????????????????????????????");
                            },
                          ),
                        ),
                      ),
                      // child: TextField(
                      //   onChanged: (value) {
                      //     // filterSearchResults(value);
                      //   },
                      //   controller: searchController,
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     labelText: "Search",
                      //     hintText: "Search",
                      //     prefixIcon: Icon(Icons.search),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(8.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // loaAllData();
                  loadData();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 280.0, top: 100),
                  child: Image.asset(
                    'images/map_icons/center map.png',
                    height: 70,
                    width: 70,
                  ),
                ),
              ),
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
  void onServiceListSuccess(List services) {
    print("on success service $services");
    for (int i = 0; i < services.length; i++) {
      var service = services[i];
      var latitude = double.parse(service['latitude']);
      var longitude = double.parse(service['longitude']);
      final iconIndex = service["category_id"];
      int phone = int.parse(service["country_code"].toString()+service["phone"]);
      // var distanceKM = getDistanceFromLatLonInKm(currentLatitude,currentLongitude,latitude,longitude);
      Map<String, dynamic> map = {
        "title": service["title"],
        "categoryId": iconIndex,
        "latLnt": LatLng(latitude, longitude),
        "serviceIcon":
            'images/categories/${servicesIconList[iconIndex - 1].imageName}',
        "imgUrl": service["img_url"],
        "phone": phone,
        "shortDescription": service["short_desc"],
        "detailedDescription": service["detailed_desc"],
      };
      serviceList.add(map);
    }
    setState(() {
      loading = false;
    });

    loaAllData();
  }
}
