import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/green_island.dart' as GreenIslandModel;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../../models/green_island.dart';
import '../../../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;

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

  void removeImageWithId(int id) {
    setState(() {
      print("Removing...");
      print(id);
      widget.greenIsland.images?.removeWhere((image) => image.id == id);
      selectedImage = null;
      //print(widget.greenIsland.images?.firstWhere((image) => image.id == id));

      carouselKey = UniqueKey();
    });
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
                        widget.greenIsland.images!.isNotEmpty)
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
                                        /*
                                  // Delete selected images from the original list
                                  widget.greenIsland.images?.removeWhere(
                                      (image) =>
                                          selectedImagePaths.contains(image));
                                  selectedImagePaths.clear();
                                  */
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

    GreenIsland updatedGreenIsland = GreenIsland();
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
