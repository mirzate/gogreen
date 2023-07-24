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
  File? _selectedImage;

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
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedImage = File(file.path!);
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
                                    child: Text('Add'),
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
                                labelText: 'Contact (optional)'),
                            maxLines: 3,
                          ),
                          SizedBox(height: 16),
                          if (_selectedImage != null)
                            Flutter.Image.file(
                              _selectedImage!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(height: 20),
                          if (_selectedImage == null)
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Other widgets on the left side
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton(
                                            onPressed: _pickImage,
                                            child: Text('Pick Image'),
                                          )))
                                ]),
                          if (_selectedImage != null)
                            IconButton(
                              icon: Expanded(
                                child: Row(
                                  children: [Icon(Icons.delete)],
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            ),
                        ])),
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

    Ecoviolation addData = Ecoviolation();

    addData.title = _titleController.text;
    addData.description = _descriptionController.text;
    addData.municipality = selectedMunicipality;

    await _ecoViolationProvider.postEcoViolation(addData, _selectedImage);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EcoViolationListScreen(),
      ),
    );
  }
}
