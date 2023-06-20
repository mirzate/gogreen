import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../screens/event_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {

  Widget? child;
  String? title;
  
  MasterScreenWidget({this.child, this.title,super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? ""), backgroundColor: Theme.of(context).primaryColor,),
      body: widget.child,
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Back'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
            ListTile(
              title: Text("Events"),
              onTap: () {
                Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventListScreen(),
                          ),
                      );
              }, 
            ),
          ],
        )
      ),
    );
  }
}