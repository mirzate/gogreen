import 'package:carousel_slider/carousel_slider.dart';
import 'package:gogreen/models/eco_violation.dart';
import 'package:gogreen/screens/admin/event/event_list_screen.dart';
import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/green_island.dart' as EventModel;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/eco_violation.dart';
import '../../../models/search_result.dart';
import '../../../providers/eco_violation_provider.dart';
import '../../../providers/other_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'eco_violation_list_screen.dart';

class EcoViolationAddScreen extends StatefulWidget {
  @override
  State<EcoViolationAddScreen> createState() => _EcoViolationAddScreenState();
}

class _EcoViolationAddScreenState extends State<EcoViolationAddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contactController;
  late EcoViolationProvider _ecoViolationProvider;
  late OtherProvider _otherProvider;
  List<Municipality>? municipalities = [];

  List<File> _selectedImages = [];
  Key carouselKey = UniqueKey();
  int currentSlideIndex = 0;

  Municipality? selectedMunicipality;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: null);
    _descriptionController = TextEditingController(text: null);
    _contactController = TextEditingController(text: null);

    _otherProvider = context.read<OtherProvider>();
    fetchMunicipalities();
  }

/*
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _datefromController.dispose();
    _datetoController.dispose();
    super.dispose();
  }
*/
  Future<void> fetchMunicipalities() async {
    try {
      var data = await _otherProvider.getMunicipalities();
      setState(() {
        municipalities = data;
      });
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

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Allow only image files
      allowMultiple: true, // Allow selecting multiple images
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      setState(() {
        _selectedImages = files.map((file) => File(file.path!)).toList();
      });
    } else {
      // User canceled the file picking process
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Eco Violation'),
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
                    Divider(
                      color: Colors.black, // Specify the color of the line
                      thickness: 1.0, // Specify the thickness of the line
                    ),
                    Form(
                        key: _formKey,
                        child: Column(children: [
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons
                                            .save_as_outlined), // Add icon to the button
                                        SizedBox(
                                            width:
                                                8), // Add some spacing between icon and text
                                        Text(
                                            'Add Eco-Violation'), // Add text to the button
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(labelText: 'Title *'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null; // Return null if the validation is successful
                              }),
                          SizedBox(height: 16),
                          TextFormField(
                              controller: _descriptionController,
                              decoration:
                                  InputDecoration(labelText: 'Description *'),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Description';
                                }
                                return null; // Return null if the validation is successful
                              }),
                          SizedBox(height: 16),
                          if (municipalities != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Municipality *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.grey[600]),
                                ),
                                DropdownButtonFormField<Municipality>(
                                    value: selectedMunicipality,
                                    items: municipalities!.map((municipality) {
                                      return DropdownMenuItem<Municipality>(
                                        value: municipality,
                                        child: Text(municipality.title ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (selectedMunicipality) {
                                      setState(() {
                                        this.selectedMunicipality =
                                            selectedMunicipality;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select an Municipality';
                                      }
                                      return null; // Return null if validation passes
                                    }),
                              ],
                            ),
                          SizedBox(height: 16),
                          TextFormField(
                              controller: _contactController,
                              decoration: InputDecoration(
                                  labelText: 'Contact Email (optional)'),
                              maxLines: 3,
                              validator: (value) {
                                if (value != null) {
                                  const emailRegex =
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                                  if (!RegExp(emailRegex).hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                }
                                return null; // Return null if the validation is successful
                              }),
                        ])),
                    SizedBox(height: 16),
                    // Add more Text or other widgets to display additional EcoViolation data
                    // List Image
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Image *',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _selectedImages.map((image) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0), // Add margin here
                                child: Stack(
                                  children: [
                                    Flutter.Image.file(
                                      image,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors
                                            .grey, // Set the background color to white
                                        child: IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors
                                              .black, // Set the icon color (e.g., red)
                                          onPressed: () {
                                            setState(() {
                                              _selectedImages.remove(image);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Pick Image'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    )

                    // End List Image
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _saveChanges() async {
    _ecoViolationProvider = context.read<EcoViolationProvider>();

    Ecoviolation addData = Ecoviolation();

    addData.title = _titleController.text;
    addData.description = _descriptionController.text;
    addData.municipality = selectedMunicipality;
    addData.contact = _contactController.text;

    await _ecoViolationProvider.postEcoViolation(addData, _selectedImages);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EcoViolationListScreen(),
      ),
    );
  }
}
