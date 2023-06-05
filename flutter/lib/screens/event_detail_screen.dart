import 'package:gogreen/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Event Details",
      child: Container(
        child: Column(
          children: const [
            Text("Details"),
          ],
        ),
      ),
    );
  }
}