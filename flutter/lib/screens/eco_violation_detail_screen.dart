import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/eco_violation.dart' as EcoviolationModel;

class EcoViolationDetailScreen extends StatefulWidget {
  
  final EcoviolationModel.Ecoviolation Ecoviolation;

  EcoViolationDetailScreen({required this.Ecoviolation});


  @override
  State<EcoViolationDetailScreen> createState() => _EcoViolationDetailScreenState();
}

class _EcoViolationDetailScreenState extends State<EcoViolationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoViolation Detail'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('Title: ${widget.Ecoviolation.title}'),
              Text('Description: ${widget.Ecoviolation.description}'),
              Text('dateFrom: ${widget.Ecoviolation.dateFrom}'),
              Text('dateTo: ${widget.Ecoviolation.dateTo}'),
              
              // Add more Text or other widgets to display additional EcoViolation data
            ],
          ),
        ),
      )
    );
  }
}
