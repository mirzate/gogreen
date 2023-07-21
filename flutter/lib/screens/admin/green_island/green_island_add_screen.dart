import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/models/green_island.dart' as GreenIslandModel;
import 'package:provider/provider.dart';
import '../../../models/green_island.dart' as MyGreenIsland;
import '../../../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;

class GreenIslandAddScreen extends StatefulWidget {
  @override
  State<GreenIslandAddScreen> createState() => _GreenIslandAddScreenState();
}

class _GreenIslandAddScreenState extends State<GreenIslandAddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  late GreenIslandProvider _greenIslandProvider;
  bool activeController = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: null);
    _descriptionController = TextEditingController(text: null);
    _longitudeController = TextEditingController(text: null);
    _latitudeController = TextEditingController(text: null);
    //_activeController = ValueNotifier(true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Green Island'),
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
                      onPressed: _saveChanges,
                      child: Text('Add'),
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

    MyGreenIsland.GreenIsland addGreenIsland = MyGreenIsland.GreenIsland();

    addGreenIsland.title = _titleController.text;
    addGreenIsland.description = _descriptionController.text;
    addGreenIsland.longitude = double.parse(_longitudeController.text);
    addGreenIsland.latitude = double.parse(_latitudeController.text);
    addGreenIsland.active = activeController;

    await _greenIslandProvider.postGreenIsland(addGreenIsland);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageGreenIslandListScreen(),
      ),
    );
  }
}
