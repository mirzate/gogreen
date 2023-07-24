import 'package:gogreen/models/event.dart';
import 'package:gogreen/screens/admin/event/event_list_screen.dart';
import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/green_island.dart' as EventModel;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/event.dart';
import '../../../models/green_island.dart' as MyEvent;
import '../../../models/search_result.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/other_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class EventAddScreen extends StatefulWidget {
  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _datefromController;
  late TextEditingController _datetoController;
  late EventProvider _eventProvider;
  late OtherProvider _otherProvider;
  List<EventType>? eventTypes = [];
  File? _selectedImage;

  bool activeController = true;
  DateTime selectedDate = DateTime.now();
  EventType? selectedEventType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: null);
    _descriptionController = TextEditingController(text: null);
    _datefromController = TextEditingController(text: null);
    _datetoController = TextEditingController(text: null);
    //_activeController = ValueNotifier(true);
    _otherProvider = context.read<OtherProvider>();
    fetchEventType();
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
  Future<void> fetchEventType() async {
    try {
      var data = await _otherProvider.getEventTypes();
      setState(() {
        eventTypes = data;
        print(eventTypes);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
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
          title: Text('Add New Event'),
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
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    if (eventTypes != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Event Type',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.grey[600]),
                          ),
                          DropdownButtonFormField<EventType>(
                            value: selectedEventType,
                            items: eventTypes!.map((eventType) {
                              return DropdownMenuItem<EventType>(
                                value: eventType,
                                child: Text(eventType.name ?? ''),
                              );
                            }).toList(),
                            onChanged: (selectedEventType) {
                              setState(() {
                                this.selectedEventType = selectedEventType;
                              });
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    TextField(
                      onTap: () async {
                        await _selectDate(context);
                        _datefromController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      },
                      controller: _datefromController,
                      decoration: InputDecoration(labelText: 'Date from'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      onTap: () async {
                        await _selectDate(context);
                        _datetoController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      },
                      controller: _datetoController,
                      decoration: InputDecoration(labelText: 'Date to'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: activeController,
                          onChanged: (newValue) {
                            setState(() {
                              activeController = newValue!;
                            });
                          },
                        ),
                        Text('Active'),
                      ],
                    ),
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 20),
                    if (_selectedImage == null)
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image'),
                      ),
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
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Other widgets on the left side
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              child: Text('Add'),
                            ),
                          ),
                        ),
                      ],
                    )

                    // Add more Text or other widgets to display additional EcoViolation data
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _saveChanges() async {
    _eventProvider = context.read<EventProvider>();

    Event addEvent = Event();

    addEvent.title = _titleController.text;
    addEvent.description = _descriptionController.text;
    addEvent.dateFrom = _datefromController.text;
    addEvent.dateTo = _datefromController.text;
    addEvent.eventType = selectedEventType;
    addEvent.active = activeController;
    await _eventProvider.postEvent(addEvent, _selectedImage);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageEventListScreen(),
      ),
    );
  }
}
