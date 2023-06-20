import 'package:gogreen/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/event.dart' as EventModel;

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
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('Title: ${widget.event.title}'),
              Text('Description: ${widget.event.description}'),
              Text('dateFrom: ${widget.event.dateFrom}'),
              Text('dateTo: ${widget.event.dateTo}'),
              Text('eventType: ${widget.event.eventType?.name}'),
              Text('MunicipalityType: ${widget.event.municipality?.title}'),
              Text('firstImage: ${widget.event.firstImage?.filePath}'),
              
              // Add more Text or other widgets to display additional event data
            ],
          ),
        ),
      ),
    );
  }
}
