import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/utils.dart';
import '../helpers/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:seva_map/pages/add_service_presenter.dart';
import '../../classes/language_constants.dart';

class AddServiceAndEvent extends StatefulWidget {
  const AddServiceAndEvent({Key? key}) : super(key: key);

  @override
  State<AddServiceAndEvent> createState() => _AddServiceAndEventState();
}

class _AddServiceAndEventState extends State<AddServiceAndEvent>
    implements AddServiceContract, AddEventContract {
  final _serviceFormKey = GlobalKey<FormState>();
  final _eventFormKey = GlobalKey<FormState>();
  late AddServicePresenter _presenter;
  late AddEventPresenter _eventPresenter;
  _AddServiceAndEventState() {
    _presenter = AddServicePresenter(this);
    _eventPresenter = AddEventPresenter(this);
  }
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
  double _longitude = 0;
  double _latitude = 0;
  bool locationSearching = false;
  var titleController = TextEditingController();
  var subtitleController = TextEditingController();
  var emailController = TextEditingController();
  var organizationController = TextEditingController();
  var countryCodeController = TextEditingController();
  var phoneController = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();
  late List services;

  var titleEventController = TextEditingController();
  var subtitleEventController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  var emailEventController = TextEditingController();
  var organizationEventController = TextEditingController();
  var countryCodeEventController = TextEditingController();
  var phoneEventController = TextEditingController();
  var latitudeEventController = TextEditingController();
  var longitudeEventController = TextEditingController();

  late String categoryId,
      title,
      shortDescription,
      detailedDescription,
      email,
      countryCode,
      phone,
      latitude,
      longitude,
      createdBy;
  late String titleEvent,
      shortDescriptionEvent,
      detailedDescriptionEvent,
      startDate,
      endDate,
      startTime,
      endTime,
      emailEvent,
      countryCodeEvent,
      phoneEvent,
      latitudeEvent,
      longitudeEvent,
      createdByEvent;

  bool isDateBefore(String date1, String date2) {
    final dateTime1 = DateTime.parse(date1);
    final dateTime2 = DateTime.parse(date2);
    return dateTime1.isBefore(dateTime2);
  }

  TimeOfDay parseTimeString(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isTimeBefore(String timeString1, String timeString2) {
    final time1 = parseTimeString(timeString1);
    final time2 = parseTimeString(timeString2);
    return isBefore(time1 as TimeOfDay, time2 as TimeOfDay);
  }

  bool isBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour && time1.minute < time2.minute) {
      return true;
    }
    return false;
  }

  submitService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final form = _serviceFormKey.currentState;
    createdBy = userId.toString();
    form?.save();
    _presenter.doAddService(
        categoryId,
        title,
        shortDescription,
        detailedDescription,
        countryCode,
        phone,
        email,
        latitude,
        longitude,
        createdBy);
  }

  submitEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final form = _eventFormKey.currentState;
    print('from even..0');
    createdBy = userId.toString();
    form?.save();
    print('from even..');
    _eventPresenter.doAddEvent(
        shortDescriptionEvent,
        detailedDescriptionEvent,
        startDate,
        endDate,
        startTime,
        endTime,
        countryCodeEvent,
        phoneEvent,
        emailEvent,
        titleEvent,
        latitudeEvent,
        longitudeEvent,
        createdBy,
        'A');
  }

  DateTime selectedStartDate = DateTime.now();
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(
          selectedEndDate.year, selectedEndDate.month, selectedEndDate.day),
      lastDate: DateTime((selectedEndDate.year + 1), selectedEndDate.month,
          selectedEndDate.day),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        startDate = "${selectedStartDate.toLocal()}".split(' ')[0];
        startDateController.text = startDate;
      });
    }
  }

  DateTime selectedEndDate = DateTime.now();
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(
          selectedEndDate.year, selectedEndDate.month, selectedEndDate.day),
      lastDate: DateTime((selectedEndDate.year + 1), selectedEndDate.month,
          selectedEndDate.day),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        endDate = "${selectedEndDate.toLocal()}".split(' ')[0];
        endDateController.text = endDate;
      });
    }
  }

  TimeOfDay selectedStartTime = TimeOfDay.now();
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedStartTime);
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        final hour = selectedStartTime.hour.toString().padLeft(2, '0');
        final minute = selectedStartTime.minute.toString().padLeft(2, '0');
        startTimeController.text = '$hour : $minute';
        startTime = '$hour:$minute:00';
      });
    }
  }

  TimeOfDay selectedEndTime = TimeOfDay.now();
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedEndTime);
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        final hour = selectedEndTime.hour.toString().padLeft(2, '0');
        final minute = selectedEndTime.minute.toString().padLeft(2, '0');
        endTimeController.text = '$hour : $minute';
        endTime = '$hour:$minute:00';
      });
    }
  }

  XFile? image;

  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String? message;

  showSnackBar(String msg) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SizedBox(
      height: 40.0,
      child: Text(msg),
    )));
  }

  uploadImage(String preName, String serviceId) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse("http://sevamap.amritacreate.org/uploader"));
    final headers = {"Content-type": "multipart/form-data"};
    final filename = selectedImage!.path.split('/').last;
    final extension = filename.split('.').last;
    final fullName = '$preName.$extension';
    request.files.add(http.MultipartFile('file',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: fullName));
    request.headers.addAll(headers);
    request.fields['service_id'] = serviceId;
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    print('service res..${res.body}');
    final resJson = jsonDecode(res.body);

    message = resJson['message'];
    print('service id..$message');
    print('...........uid.......${resJson['message']}');
    showSnackBar(message!);
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    selectedImage = File(img!.path);
    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(translation(context).please_choose_media),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text(translation(context).from_gallery),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text(translation(context).from_camera),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  int? selectedService;
  @override
  Widget build(BuildContext context) {
    services = Utils.getMockedCategories(context);
    return Stack(
      children: [
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
            height: MediaQuery.of(context).size.height - 100,
            //  padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: -20,
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'images/bottom_menu/icon-calendar.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, top: 18, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Color(0xFFff5b51),
                              fontFamily: 'Nunito',
                            ),
                            child: AutoSizeText(
                                translation(context).add_One_plus1,
                                style: TextStyle(fontSize: 36.0),
                                maxLines: 1),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                                        maxWidth: 100.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      translation(context).service,
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
                                        maxWidth: 160.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      translation(context).calendar_events,
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
                        const SizedBox(
                          height: 12.0,
                        ),
                        eventSelected
                            ? Form(
                                key: _serviceFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            hint: Text(
                                                translation(context).service),
                                            value: selectedService,
                                            items: services
                                                .map<DropdownMenuItem<int>>(
                                                  (e) => DropdownMenuItem(
                                                    value:
                                                        services.indexOf(e) + 1,
                                                    child: Text(e.title),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              print('.....//$value');
                                              setState(() {
                                                selectedService = value!;
                                                categoryId =
                                                    selectedService.toString();
                                              });
                                              print('.....//$selectedService');
                                            }),
                                      ),
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).title)),
                                        onSaved: (val) =>
                                            shortDescription = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .title_is_mandatory;
                                          }
                                          if (!RegExp(
                                                  r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                              .hasMatch(val!)) {
                                            return 'Enter Valid Title';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: subtitleController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).subtitle)),
                                        onSaved: (val) =>
                                            detailedDescription = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .subtitle_is_mandatory;
                                          }
                                          if (!RegExp(
                                                  r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                              .hasMatch(val!)) {
                                            return 'Enter Valid Sub-Title';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).email)),
                                        onSaved: (val) => email = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .email_is_mandatory;
                                          }
                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)) {
                                            return 'Enter a valid Email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller: countryCodeController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .country_code)),
                                              onSaved: (val) =>
                                                  countryCode = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .country_code_is_mandatory;
                                                }
                                                if (!RegExp(r"^[+]+[0-9()]")
                                                    .hasMatch(val)) {
                                                  return 'Enter a valid Country code!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Material(
                                            child: TextFormField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .phone_Number)),
                                              onSaved: (val) => phone = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .phone_number_is_mandatory;
                                                }
                                                if (!RegExp(r"^[0-9]")
                                                    .hasMatch(val)) {
                                                  return 'Enter a valid Phone number!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: organizationController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(translation(context)
                                                .organization_Name)),
                                        onSaved: (val) => title = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .organization_name_is_mandatory;
                                          }
                                          if (!RegExp(r'^[a-zA-Z 0-9@]+$')
                                              .hasMatch(val!)) {
                                            return 'Enter Valid Organization Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller: latitudeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .latitude)),
                                              onSaved: (val) => latitude = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .latitude_is_mandatory;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller: longitudeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .longitude)),
                                              onSaved: (val) =>
                                                  longitude = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .longitude_is_mandatory;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    locationSearching = true;
                                                  });
                                                  Utils.getCurrentLocation()
                                                      .then((value) {
                                                    setState(() {
                                                      locationSearching = false;
                                                      latitudeController.text =
                                                          value.latitude
                                                              .toString();
                                                      longitudeController.text =
                                                          value.longitude
                                                              .toString();
                                                    });
                                                  });
                                                },
                                                child: locationSearching
                                                    ? const SizedBox(width: 30, height: 30 ,child: Center(child: CircularProgressIndicator(color: Color(0xFFffa9ca),),),)
                                                    : const Icon(Icons.search,
                                                        color:
                                                            Color(0xFFffa9ca),
                                                        size: 30),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        DefaultTextStyle(
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Nunito',
                                          ),
                                          child: AutoSizeText(
                                              translation(context).select_image,
                                              style: TextStyle(fontSize: 16.0),
                                              maxLines: 1),
                                        ),
                                        GestureDetector(
                                          onTap: myAlert,
                                          child: const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Icon(Icons.image),
                                          ),
                                        ),
                                        image != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    //to show image, you type like this.
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                    width: 100, height: 100,
                                                  ),
                                                ),
                                              )
                                            : Image.asset(
                                                'images/add_service/upload image.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 40.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_serviceFormKey.currentState!
                                                .validate()) {
                                              submitService();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              padding: const EdgeInsets.all(0)),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: selectedButtonBg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 160.0,
                                                  minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                translation(context).submit,
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
                                    ),
                                  ],
                                ),
                              )
                            : Form(
                                /*------------------------------- Form to Add Events ---------------------------------*/
                                key: _eventFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      child: TextFormField(
                                        controller: titleEventController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).title)),
                                        onSaved: (val) =>
                                            shortDescriptionEvent = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .title_is_mandatory;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: subtitleEventController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).subtitle)),
                                        onSaved: (val) =>
                                            detailedDescriptionEvent = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .subtitle_is_mandatory;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Material(
                                            child: TextFormField(
                                              controller: startDateController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .calendar_today), //icon of text field
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .start_date)),
                                              onSaved: (val) =>
                                                  startDate = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .start_date_is_mandatory;
                                                }
                                                if (isDateBefore(
                                                    endDate, startDate)) {
                                                  return "start_date_must_be_before_end_date";
                                                }
                                                return null;
                                              },
                                              onTap: () =>
                                                  _selectStartDate(context),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Material(
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: endDateController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .calendar_today), //icon of text field
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .end_date)),
                                              onSaved: (val) => endDate = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .end_date_is_mandatory;
                                                }

                                                if (isDateBefore(
                                                    endDate, startDate)) {
                                                  return "end_date_must_be_after_start_date";
                                                }
                                                return null;
                                              },
                                              onTap: () =>
                                                  _selectEndDate(context),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Material(
                                            child: TextFormField(
                                              controller: startTimeController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .access_time), //icon of text field
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .start_time)),
                                              onSaved: (val) =>
                                                  startTime = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .start_time_is_mandatory;
                                                }
                                                return null;
                                              },
                                              onTap: () =>
                                                  _selectStartTime(context),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Material(
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: endTimeController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons
                                                      .access_time), //icon of text field
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .end_date)),
                                              onSaved: (val) => endTime = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .end_date_is_mandatory;
                                                }
                                                if (startDate == endDate) {
                                                  if (isTimeBefore(
                                                      endTime, startTime)) {
                                                    return "end_time_must_be_after_start_time";
                                                  }
                                                }
                                                return null;
                                              },
                                              onTap: () =>
                                                  _selectEndTime(context),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: emailEventController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(
                                                translation(context).email)),
                                        onSaved: (val) => emailEvent = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .email_is_mandatory;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller:
                                                  countryCodeEventController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .country_code)),
                                              onSaved: (val) =>
                                                  countryCodeEvent = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .country_code_is_mandatory;
                                                }
                                                if (!RegExp(r"^[+]+[0-9()]")
                                                    .hasMatch(val)) {
                                                  return 'Enter a valid Country code!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Material(
                                            child: TextFormField(
                                              controller: phoneEventController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .phone_Number)),
                                              onSaved: (val) =>
                                                  phoneEvent = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .phone_number_is_mandatory;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Material(
                                      child: TextFormField(
                                        controller: organizationEventController,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            label: Text(translation(context)
                                                .organization_name)),
                                        onSaved: (val) => titleEvent = val!,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return translation(context)
                                                .organization_name_is_mandatory;
                                          }
                                          if (!RegExp(r'^[a-zA-Z 0-9@]+$')
                                              .hasMatch(val!)) {
                                            return 'Enter Valid Organization Name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller:
                                                  latitudeEventController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .latitude)),
                                              onSaved: (val) =>
                                                  latitudeEvent = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .latitude_is_mandatory;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Material(
                                            child: TextFormField(
                                              controller:
                                                  longitudeEventController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  label: Text(
                                                      translation(context)
                                                          .longitude)),
                                              onSaved: (val) =>
                                                  longitudeEvent = val!,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return translation(context)
                                                      .longitude_is_mandatory;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    locationSearching = true;
                                                  });
                                                  Utils.getCurrentLocation()
                                                      .then((value) {
                                                    setState(() {
                                                      locationSearching = false;
                                                      latitudeEventController
                                                              .text =
                                                          value.latitude
                                                              .toString();
                                                      longitudeEventController
                                                              .text =
                                                          value.longitude
                                                              .toString();
                                                    });
                                                    print(value.latitude);
                                                    print(value.longitude);
                                                  });
                                                },
                                                child: locationSearching
                                                    ? const SizedBox(width: 30, height: 30 ,child: Center(child: CircularProgressIndicator(color: Color(0xFFffa9ca),),),)
                                                    : const Icon(Icons.search,
                                                    color:
                                                    Color(0xFFffa9ca),
                                                    size: 30),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        DefaultTextStyle(
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Nunito',
                                          ),
                                          child: AutoSizeText(
                                              translation(context).select_image,
                                              style: TextStyle(fontSize: 16.0),
                                              maxLines: 1),
                                        ),
                                        GestureDetector(
                                          onTap: myAlert,
                                          child: const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Icon(Icons.image),
                                          ),
                                        ),
                                        image != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    //to show image, you type like this.
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                    width: 100, height: 100,
                                                  ),
                                                ),
                                              )
                                            : Image.asset(
                                                'images/add_service/upload image.png',
                                                width: 100,
                                                height: 100,
                                              ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 40.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_eventFormKey.currentState!
                                                .validate()) {
                                              submitEvents();
                                            }
                                            print(titleEventController.text);
                                            print(subtitleEventController.text);
                                            print(emailEventController.text);
                                            print(countryCodeEventController
                                                .text);
                                            print(phoneEventController.text);
                                            print(organizationEventController
                                                .text);
                                            print(latitudeEventController.text);
                                            print(
                                                longitudeEventController.text);
                                            print(startDate);
                                            print(endDate);
                                            print(startTime);
                                            print(endTime);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              padding: const EdgeInsets.all(0)),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: selectedButtonBg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 160.0,
                                                  minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                translation(context).submit,
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
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ],
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
      ],
    );
    ;
  }

  @override
  void onAddServiceError(String errorTxt) {
    // TODO: implement onAddServiceError
    print('From error $errorTxt');
  }

  @override
  void onAddServiceSuccess(String serviceId) {
    // TODO: implement onAddServiceSuccess
    print('From success $serviceId');
    final String preName = 'service_$serviceId';
    uploadImage(preName, serviceId);
  }

  @override
  void onAddEventError(String errorTxt) {
    print('From event error $errorTxt');
  }

  @override
  void onAddEventSuccess(String eventId) {
    print('From event success $eventId');
    final String preName = 'event_$eventId';
    uploadImage(preName, eventId);
  }
}
