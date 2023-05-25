import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seva_map/pages/home_button.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _selectedDate = DateTime.now();

  final List<Event> _events = [
    Event('Health Clinic and Medical Check-Up',
        DateTime.now().subtract(Duration(days: 1)), 'UNCR Zon 4', 'Uganda'),
    Event('Women Empowerment Workshop', DateTime.now(), 'UNCR Zon 4', ''),
    Event(
        "Children's Art and Recreation Day", DateTime.now(), 'UNCR Zon 4', ''),
    Event('Cultural Festival', DateTime.now().add(Duration(days: 1)),
        'UNCR Zon 4', ''),
    Event('Peacebuilding and Conflict Resolution Workshop',
        DateTime.now().add(Duration(days: 2)), 'UNCR Zon 4', ''),
    Event('Livelihood and Entrepreneurship Fair',
        DateTime.now().add(Duration(days: 3)), 'UNCR Zon 4', ''),
  ];

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(10, 228, 235, 1),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    color: Colors.white70,
                    child: CalendarCarousel(
                      onDayPressed: (DateTime date, List events) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      markedDateCustomShapeBorder: const CircleBorder(
                        side: BorderSide(
                          color: Colors.pink,
                          width: 2,
                        ),
                      ),
                      markedDateCustomTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: _getEventsForDay(_selectedDate).length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = _getEventsForDay(_selectedDate)[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Nunito"),
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.details,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: "Nunito",
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.date.toString().split(' ')[0],
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: "Nunito",
                                    ),
                                  ),
                                  Text(
                                    event.date.toString().split(' ')[1],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: "Nunito",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 80,
                                child: Image(
                                  image: AssetImage(
                                      "images/selected_service/directions.png"),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Event Details'),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        event.title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        event.details,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Date: ${event.date.toString().split(' ')[0]}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Time: ${event.date.toString().split(' ')[1]}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Location: ${event.location}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          child: HomeButton(),
          left: 0,
          top: 10,
        ),
      ],
    );
  }
}

class Event {
  final String title;
  final DateTime date;
  final String details;
  final String location;

  Event(this.title, this.date, this.details, this.location);
}
