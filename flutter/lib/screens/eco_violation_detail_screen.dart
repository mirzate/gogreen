import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/eco_violation.dart' as EcoviolationModel;
import 'package:carousel_slider/carousel_slider.dart';

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
        child: Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.Ecoviolation.images != null && widget.Ecoviolation.images!.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200, // Set the height of the carousel
                        enableInfiniteScroll: true, // Allow infinite scrolling
                        autoPlay: true, // Enable auto-play
                        autoPlayInterval: Duration(seconds: 3), // Set auto-play interval
                        autoPlayAnimationDuration: Duration(milliseconds: 800), // Set animation duration
                        pauseAutoPlayOnTouch: true, // Pause auto-play on touch
                      ),
                      items: widget.Ecoviolation.images?.map((image) {
                        return Image.network(image.filePath.toString() ?? "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png"); // Replace with your image property name
                      }).toList() ?? [],
                    ),
                  Divider(
                    color: Colors.black, // Specify the color of the line
                    thickness: 1.0, // Specify the thickness of the line
                  ),
                  Text(widget.Ecoviolation.title.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Text(widget.Ecoviolation.description.toString()),
                  Text('Contact: ${widget.Ecoviolation.contact}'),
                  Divider(),
                  
                  Text('Municipality: ${widget.Ecoviolation.municipality?.title}'),
                  Text('Municipality Response: ${widget.Ecoviolation.response}'),
                  // Add more Text or other widgets to display additional EcoViolation data
                ],
              ),
            ),
          ),
        ),
     )
    );
  }
}
