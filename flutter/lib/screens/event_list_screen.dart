import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/event_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import '../providers/token_provider.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  TextEditingController _fullTextSearchController = new TextEditingController();
  late EventProvider _eventProvider;
  SearchResult<Event>? eventResults;
  int currentPage = 1;
  int pageSize = 6;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventProvider = context.read<EventProvider>();
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
      print(params);
      var data = await _eventProvider.get(params: params);
      setState(() {
        eventResults = data;
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

  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      title: "Event List",
      child: Container(
        child: Column(
          children: [_buildSearch(), _buildListView(), _pagination()],
        ),
      ),
    );
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

  Expanded _buildListView() {
    double maxWidth = 400; // Set your desired maximum width for mobile devices
    double minWidth = 300;

    return Expanded(
      child: ListView.builder(
        itemCount: eventResults?.result.length ?? 0,
        itemBuilder: (context, index) {
          Event event = eventResults!.result[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            child: Center(
              // Wrap the Container with Center to keep it centered
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minWidth: minWidth), // Set the maximum width constraint
                color: Colors.grey[300],
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[50]!),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${event.title}',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Image.network(
                        event.firstImage?.filePath ??
                            'https://example.com/placeholder.jpg',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                      // Add other widgets for additional data display
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: (eventResults?.pageIndex ?? 0) != 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              setState(() {
                if (currentPage > 1) {
                  currentPage--;
                }
              });
              await fetchData();
              //print(currentPage);
            },
          ),
        ),
        Text('Page $currentPage'),
        Visibility(
          visible: currentPage < (eventResults?.totalPages ?? 0),
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              setState(() {
                currentPage++;
              });
              await fetchData();
            },
          ),
        ),
      ],
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(
      children: [
        DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'ID',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'Title',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'Active',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'Image',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: eventResults?.result
                    .map((Event e) => DataRow(
                            onSelectChanged: (value) => {
                                  if (value == true)
                                    {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailScreen(event: e),
                                        ),
                                      )
                                    }
                                },
                            cells: [
                              DataCell(Text(e.id?.toString() ?? "")),
                              DataCell(Text(e.title?.toString() ?? "")),
                              DataCell(Text(e.active?.toString() ?? "")),
                              DataCell(Container(
                                  width: 80,
                                  height: 80,
                                  child: Flutter.Image.network(
                                    e.firstImage?.filePath.toString() ??
                                        "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png",
                                    //width: 200, // Set the desired width of the image
                                    //height: 200, // Set the desired height of the image
                                  ))),
                            ]))
                    .toList() ??
                []),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: (eventResults?.pageIndex ?? 0) != 1,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  setState(() {
                    if (currentPage > 1) {
                      currentPage--;
                    }
                  });
                  await fetchData();
                  //print(currentPage);
                },
              ),
            ),
            Text('Page $currentPage'),
            Visibility(
              visible: currentPage < (eventResults?.totalPages ?? 0),
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () async {
                  setState(() {
                    currentPage++;
                  });
                  await fetchData();
                },
              ),
            ),
          ],
        )
      ],
    )));
  }
}
