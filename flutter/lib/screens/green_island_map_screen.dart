import 'dart:async';

import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/eco_violation_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/green_island.dart';
import '../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import '../providers/token_provider.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class GreenIslandMapScreen extends StatefulWidget {
  const GreenIslandMapScreen({super.key});

  @override
  State<GreenIslandMapScreen> createState() => _GreenIslandMapScreenState();
}

class _GreenIslandMapScreenState extends State<GreenIslandMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  TextEditingController _fullTextSearchController = new TextEditingController();
  late GreenIslandProvider _GreenIslandProvider;
  SearchResult<GreenIsland>? result;
  int currentPage = 1;
  int pageSize = 50;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _GreenIslandProvider = context.read<GreenIslandProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      //_fullTextSearchController.clear(); // Da je potrebno obrisati

      var params = {
        "fullTextSearch": _fullTextSearchController.text,
        "pageIndex": currentPage,
        "pageSize": pageSize,
      };
      var data = await _GreenIslandProvider.get(params: params);
      setState(() {
        result = data as SearchResult<GreenIsland>?;
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

  final LatLng _defaultPosition =
      LatLng(43.856258, 18.413076); // Default position coordinates Sarajevo

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: Column(
          children: [
            _buildSearch(),
            Expanded(
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: _defaultPosition, // Set the default position
                  zoom: 12, // Set the default zoom level
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  addMarkers(controller);
                },
                markers: _markers,
              ),
            )
          ],
        ),
      ),
      /*
      floatingActionButton: Container(
        child: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
        // Add any desired properties or constraints to the Container
      ),
      */
    );
  }

  Set<Marker> _markers =
      {}; // Define a Set<Marker> variable to hold the markers

  void addMarkers(GoogleMapController controller) {
    if (result != null) {
      for (var item in result!.result) {
        Marker marker = Marker(
          markerId: MarkerId(item.id.toString()), // Provide a unique marker ID
          position: LatLng(
              item.latitude, item.longitude), // Set the latitude and longitude
          infoWindow: InfoWindow(
            title: item.title,
            snippet: item.description,
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      }
    }
    // Optionally move the camera to the first marker's position
    if (_markers.isNotEmpty) {
      controller.animateCamera(
        CameraUpdate.newLatLng(_markers.first.position),
      );
    }
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                suffixIcon: _fullTextSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _fullTextSearchController.clear();
                          fetchData();
                        },
                      )
                    : null,
              ),
              controller: _fullTextSearchController,
              onSubmitted: (String value) {
                currentPage = 1;
                fetchData();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
