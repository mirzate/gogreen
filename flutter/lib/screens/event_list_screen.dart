
import 'package:gogreen/screens/event_detail_screen.dart';
import 'package:gogreen/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  late EventProvider _eventProvider;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _eventProvider = context.read<EventProvider>();
  }
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Event List",
      child: Container(
        child: Column(
          children: [
            Text("Events"),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
            ),),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EventDetailScreen(),
                    ),
                );
              },
              child: Text("Details"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
            ),),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                var data = await _eventProvider.get();
                print(data.result[0].title);
              },
              child: Text("Get Data from EP"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
            ),)
          ],
        ),
        ),
      );
  }
}