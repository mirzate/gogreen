import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/green_island.dart' as GreenIslandModel;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../../models/green_island.dart' as MyGreenIsland;
import '../../../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;
//import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class GreenIslandEditScreen extends StatefulWidget {
  final GreenIslandModel.GreenIsland greenIsland;

  GreenIslandEditScreen({required this.greenIsland});

  @override
  State<GreenIslandEditScreen> createState() => _GreenIslandEditScreenState();
}

class _GreenIslandEditScreenState extends State<GreenIslandEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  late GreenIslandProvider _greenIslandProvider;
  int currentSlideIndex = 3;
  List<String> selectedImagePaths = [];
  int? selectedImage;
  File? _selectedImage;

  Key carouselKey = UniqueKey(); // Add a unique key to the CarouselSlider

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.greenIsland.title);
    _descriptionController =
        TextEditingController(text: widget.greenIsland.description);
    _longitudeController =
        TextEditingController(text: widget.greenIsland.longitude.toString());
    _latitudeController =
        TextEditingController(text: widget.greenIsland.latitude.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }
/*
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }
  */

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
    _greenIslandProvider = context.read<GreenIslandProvider>();
    var updatedGreenIsland = await _greenIslandProvider.uploadImage(
        widget.greenIsland, _selectedImage!);

    if (updatedGreenIsland != null) {
      setState(() {
        widget.greenIsland.images = updatedGreenIsland.images;
        widget.greenIsland.images
            ?.sort((a, b) => (b?.id ?? 0).compareTo(a?.id ?? 0));

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
      widget.greenIsland.images?.removeWhere((image) => image.id == id);
      selectedImage = null;
      //print(widget.greenIsland.images?.firstWhere((image) => image.id == id));

      carouselKey = UniqueKey();
    });

    _greenIslandProvider = context.read<GreenIslandProvider>();
    await _greenIslandProvider.deleteGreenIslandImage(widget.greenIsland, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Green Island'),
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
                    if (widget.greenIsland.images != null &&
                        widget.greenIsland.images!.isNotEmpty &&
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
                                      widget.greenIsland.images![index].id;

                                  print(selectedImage);
                                });
                                //print(currentSlideIndex);
                              },
                            ),
                            items: widget.greenIsland.images?.map((image) {
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
                    TextField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save Changes'),
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
    _greenIslandProvider = context.read<GreenIslandProvider>();

    MyGreenIsland.GreenIsland updatedGreenIsland = MyGreenIsland.GreenIsland();
    updatedGreenIsland.id = widget.greenIsland.id;
    updatedGreenIsland.title = _titleController.text;
    updatedGreenIsland.description = _descriptionController.text;
    updatedGreenIsland.longitude = double.parse(_longitudeController.text);
    updatedGreenIsland.latitude = double.parse(_latitudeController.text);

    await _greenIslandProvider.putGreenIsland(updatedGreenIsland);

    // Replace the current screen with ManageGreenIslandListScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ManageGreenIslandListScreen(),
      ),
    );
  }
}
