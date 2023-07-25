import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/eco_violation.dart';
import '../../../providers/eco_violation_provider.dart';
import 'package:flutter/material.dart' as Flutter;
//import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../providers/other_provider.dart';
import 'eco_violation_list_screen.dart';

class EcoViolationEditScreen extends StatefulWidget {
  late final Ecoviolation ecoViolation;

  EcoViolationEditScreen({required this.ecoViolation});

  @override
  State<EcoViolationEditScreen> createState() => _EcoViolationEditScreenState();
}

class _EcoViolationEditScreenState extends State<EcoViolationEditScreen> {
  late TextEditingController _responseController;

  late EcoViolationProvider _ecoViolationProvider;
  late OtherProvider _otherProvider;
  List<EcoViolationStatus>? ecoViolationStatus = [];
  int currentSlideIndex = 3;

  EcoViolationStatus? selectedEcoViolationStatus;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _responseController =
        TextEditingController(text: widget.ecoViolation.response);
    _otherProvider = context.read<OtherProvider>();
    fetchEcoViolationStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchEcoViolationStatus() async {
    try {
      var data = await _otherProvider.getEcoViolationStatus();
      setState(() {
        ecoViolationStatus = data;
      });

      var tmp = ecoViolationStatus!.firstWhere((eventType) =>
          eventType.id == widget.ecoViolation.ecoViolationStatus?.id);
      selectedEcoViolationStatus = tmp;
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Eco Violation'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.ecoViolation.images != null &&
                        widget.ecoViolation.images!.isNotEmpty)
                      Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200,
                              enableInfiniteScroll: true,
                              autoPlay:
                                  false, // Disable auto-play, as we are handling navigation manually
                              initialPage: currentSlideIndex,
                            ),
                            items: widget.ecoViolation.images?.map((image) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Add or remove the image path from the selectedImagePaths list on tap
                                      setState(() {});
                                    },
                                    child: Flutter.Image.network(
                                      image.filePath.toString() ??
                                          "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png",
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ],
                      ),

                    Divider(
                      color: Colors.black, // Specify the color of the line
                      thickness: 1.0, // Specify the thickness of the line
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _responseController,
                              decoration:
                                  InputDecoration(labelText: 'Response *'),
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Response';
                                }
                                return null; // Return null if the validation is successful
                              }),
                          SizedBox(height: 16),
                          if (ecoViolationStatus != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select status *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                DropdownButtonFormField<EcoViolationStatus>(
                                  value: selectedEcoViolationStatus,
                                  items: ecoViolationStatus!.map((data) {
                                    return DropdownMenuItem<EcoViolationStatus>(
                                      value: data,
                                      child: Text(data.name ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (selectedEcoViolationStatus) {
                                    setState(() {
                                      this.selectedEcoViolationStatus =
                                          selectedEcoViolationStatus;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select an status';
                                    }
                                    return null; // Return null if validation passes
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Other widgets on the left side
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveChanges(); // <-- Call the function using ()
                                      }
                                    },
                                    child: Text('Save Changes'),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    // Add more Text or other widgets to display additional EcoViolation data
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _saveChanges() async {
    _ecoViolationProvider = context.read<EcoViolationProvider>();

    Ecoviolation updatedEcoviolation = Ecoviolation();
    updatedEcoviolation.id = widget.ecoViolation.id;
    updatedEcoviolation.response = _responseController.text;
    updatedEcoviolation.ecoViolationStatus = selectedEcoViolationStatus;

    await _ecoViolationProvider.putEcoViolation(updatedEcoviolation);

    // Replace the current screen with ManageGreenIslandListScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageEcoViolationListScreen(),
      ),
    );
  }
}
