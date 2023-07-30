import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/event.dart' as EventModel;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel.Event event;

  EventDetailScreen({required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.event.images != null &&
                      widget.event.images!.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200, // Set the height of the carousel
                        enableInfiniteScroll: true, // Allow infinite scrolling
                        autoPlay: true, // Enable auto-play
                        autoPlayInterval:
                            Duration(seconds: 3), // Set auto-play interval
                        autoPlayAnimationDuration: Duration(
                            milliseconds: 800), // Set animation duration
                        pauseAutoPlayOnTouch: true, // Pause auto-play on touch
                      ),
                      items: widget.event.images?.map((image) {
                            return Image.network(image.filePath.toString() ??
                                "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png"); // Replace with your image property name
                          }).toList() ??
                          [],
                    ),
                  Text(widget.event.title.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Description: ${widget.event.description}'),
                  Text(
                      'Date From: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.event.dateFrom as String))}'),
                  Text(
                      'Date To: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.event.dateTo as String))}'),
                  Text('Event Type: ${widget.event.eventType?.name}'),
                  Text(
                      'Municipality / Location: ${widget.event.municipality?.title}'),
                  // Add more Text or other widgets to display additional event data
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
