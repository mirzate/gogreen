import 'package:gogreen/providers/event_provider.dart';
import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/event.dart' as EventModel;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/event.dart';
import '../../../providers/event_provider.dart';
import 'package:flutter/material.dart' as Flutter;
//import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../providers/other_provider.dart';
import 'event_list_screen.dart';

class EventEditScreen extends StatefulWidget {
  final EventModel.Event event;

  EventEditScreen({required this.event});

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _datefromController;
  late TextEditingController _datetoController;
  late EventProvider _eventProvider;
  late OtherProvider _otherProvider;
  List<EventType>? eventTypes = [];
  int currentSlideIndex = 3;
  List<String> selectedImagePaths = [];
  int? selectedImage;
  File? _selectedImage;
  bool activeController = true;
  DateTime selectedDate = DateTime.now();
  EventType? selectedEventType;
  Key carouselKey = UniqueKey(); // Add a unique key to the CarouselSlider
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _titleIsValid = true;
  bool _descriptionIsValid = true;
  bool _dateFromIsValid = true;
  bool _dateToIsValid = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _datefromController = TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.event.dateFrom as String)));
    _datetoController = TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.event.dateTo as String)));
    activeController = widget.event.active!;
    _otherProvider = context.read<OtherProvider>();
    fetchEventType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchEventType() async {
    try {
      var data = await _otherProvider.getEventTypes();
      setState(() {
        eventTypes = data;
        //print(eventTypes![0]);
      });

      var tmp = eventTypes!.firstWhere(
          (eventType) => eventType.id == widget.event.eventType?.id);
      selectedEventType = tmp;
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

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      return;
    }
    _eventProvider = context.read<EventProvider>();

    var updatedEvent =
        await _eventProvider.uploadImage(widget.event, _selectedImage!);

    if (updatedEvent != null) {
      setState(() {
        widget.event.images = updatedEvent.images;
        widget.event.images?.sort((a, b) => (b?.id ?? 0).compareTo(a?.id ?? 0));

        carouselKey = UniqueKey();
      });
    }

    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> removeImageWithId(int id) async {
    setState(() {
      print("Removing...");
      print(id);
      widget.event.images?.removeWhere((image) => image.id == id);
      selectedImage = null;
      //print(widget.greenIsland.images?.firstWhere((image) => image.id == id));

      carouselKey = UniqueKey();
    });

    _eventProvider = context.read<EventProvider>();
    await _eventProvider.deleteEventImage(widget.event, id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Event'),
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
                    if (widget.event.images != null &&
                        widget.event.images!.isNotEmpty &&
                        _selectedImage == null)
                      Column(
                        children: [
                          CarouselSlider(
                            key:
                                carouselKey, // Set the key to the CarouselSlider
                            options: CarouselOptions(
                              height: 200,
                              enableInfiniteScroll: true,
                              autoPlay:
                                  false, // Disable auto-play, as we are handling navigation manually
                              initialPage: currentSlideIndex,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  print("onPageChanged Image selected");

                                  currentSlideIndex = index;
                                  // Update selectedImage with the ID of the currently shown image
                                  selectedImage =
                                      widget.event.images![index].id;

                                  print(selectedImage);
                                });
                                //print(currentSlideIndex);
                              },
                            ),
                            items: widget.event.images?.map((image) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Add or remove the image path from the selectedImagePaths list on tap
                                      setState(() {
                                        print("onTap");
                                        selectedImage = image.id;
                                        print("Image selected:");
                                        print(selectedImage);
                                      });
                                    },
                                    child: Flutter.Image.network(
                                      image.filePath.toString() ??
                                          "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png",
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  // Move to the previous slide
                                  setState(() {
                                    currentSlideIndex = currentSlideIndex > 0
                                        ? currentSlideIndex - 1
                                        : widget.greenIsland.images!.length - 1;
                                    carouselKey = UniqueKey();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // Move to the next slide
                                  setState(() {
                                    currentSlideIndex =
                                        (currentSlideIndex + 1) %
                                            widget.greenIsland.images!.length;
                                    carouselKey = UniqueKey();
                                  });
                                },
                              ),
                              */
                              if (selectedImage != null)
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Implement the logic to delete selected images here
                                    setState(() {
                                      if (selectedImage != null) {
                                        print("Image was selected:");
                                        print(selectedImage);
                                        removeImageWithId(selectedImage!);
                                      } else {
                                        print("Image was not selecte");
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    /* // For mob version
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 50),
                          ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: Text('Take Photo'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: Text('Choose from Gallery'),
                        ),
                      ],
                    ),
                    */
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
                    SizedBox(height: 10),
                    if (_selectedImage != null)
                      ElevatedButton(
                        onPressed: _uploadImage,
                        child: Text('Upload Image'),
                      ),
                    SizedBox(height: 10),
                    if (_selectedImage != null)
                      ElevatedButton(
                        onPressed: _uploadImage,
                        child: Text('Cancel'),
                      ),
                    Divider(
                      color: Colors.black, // Specify the color of the line
                      thickness: 1.0, // Specify the thickness of the line
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: 'Title *',
                                errorText: _descriptionIsValid
                                    ? null
                                    : 'Please enter a Title',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _titleIsValid = value.isNotEmpty;
                                });
                              }),
                          SizedBox(height: 16),
                          TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description *',
                                errorText: _descriptionIsValid
                                    ? null
                                    : 'Please enter a description',
                              ),
                              maxLines: 3,
                              onChanged: (value) {
                                setState(() {
                                  _descriptionIsValid = value.isNotEmpty;
                                });
                              }),
                          SizedBox(height: 16),
                          if (eventTypes != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Event Type *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
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
                                      this.selectedEventType =
                                          selectedEventType;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select an event type';
                                    }
                                    return null; // Return null if validation passes
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: 16),
                          TextField(
                              onTap: () async {
                                await _selectDate(context);
                                _datefromController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                              },
                              controller: _datefromController,
                              decoration: InputDecoration(
                                labelText: 'Date from *',
                                errorText: _dateFromIsValid
                                    ? null
                                    : 'Please enter a Date From',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _dateFromIsValid = value.isNotEmpty;
                                });
                              }),
                          SizedBox(height: 16),
                          TextField(
                              onTap: () async {
                                await _selectDate(context);
                                _datetoController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                              },
                              controller: _datetoController,
                              decoration: InputDecoration(
                                labelText: 'Date to *',
                                errorText: _dateFromIsValid
                                    ? null
                                    : 'Please enter a Date To',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _dateToIsValid = value.isNotEmpty;
                                });
                              }),
                          SizedBox(height: 16),
                          Checkbox(
                            value: activeController,
                            onChanged: (newValue) {
                              setState(() {
                                activeController = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _descriptionIsValid! &&
                                  _titleIsValid! &&
                                  _dateFromIsValid! &&
                                  _dateToIsValid!) {
                                _saveChanges();
                              }
                            },
                            child: Text('Save Changes'),
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
    print("Save 0");
    _eventProvider = context.read<EventProvider>();

    EventModel.Event updatedEvent = EventModel.Event();
    updatedEvent.id = widget.event.id;
    updatedEvent.title = _titleController.text;
    updatedEvent.description = _descriptionController.text;
    updatedEvent.dateFrom = _datefromController.text;
    updatedEvent.dateTo = _datetoController.text;
    updatedEvent.typeId = selectedEventType?.id ?? 1;
    updatedEvent.active = activeController;

    await _eventProvider.putEvent(updatedEvent);
    print("Save 1");
    // Replace the current screen with ManageGreenIslandListScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageEventListScreen(),
      ),
    );
  }
}
