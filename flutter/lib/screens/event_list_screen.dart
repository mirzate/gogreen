
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/event_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'package:flutter/material.dart' as Flutter;

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  TextEditingController _fullTextSearchController = new TextEditingController();
  late EventProvider _eventProvider;
  SearchResult<Event>? result;
  int currentPage = 1;
  int pageSize = 6;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _eventProvider = context.read<EventProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {

      _fullTextSearchController.clear();

      var data = await _eventProvider.get(
        params: {
          "fullTextSearch": _fullTextSearchController.text,
          "pageIndex": currentPage,
          "pageSize": pageSize,
        },
      );
      setState(() {
        result = data;
      });
    } catch (error) {
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text(error.toString()),
          actions: [
            TextButton(onPressed: ()=> Navigator.pop(context), child: Text("Ok"))
          ],
      ));

    }
  }

  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Event List",
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView()
          ],
        ),
        ),
      );
  }

  Widget _buildSearch(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
              Expanded(
                child: TextField(
                      decoration: InputDecoration(
                        labelText: "Search",
                        prefixIcon: Icon(Icons.search)
                      ),
                      controller: _fullTextSearchController,
                    ),
              ),
              SizedBox(height: 10,),
              /*
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Back"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                    ),
                ),
              ),
              */
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EventDetailScreen(),
                      ),
                  );
                },
                child: Text("Details"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
              ),),
              SizedBox(height: 10,),
              /*
              ElevatedButton(
                onPressed: () async {
                  var data = await _eventProvider.get(params: {
                    "fullTextSearch": _fullTextSearchController.text
                  });
                  setState(() {
                    result = data;
                  });
                  print(data.result[0].title);
                  print(result);
                  
                },
                child: Text("Get Data from EP"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
              ),)
              */
      ],),
    );
  }
  Expanded _buildDataListView() {
    return Expanded(child: 
            SingleChildScrollView(child: 
              Column(
                children: [
                  DataTable(
                    columns: [
                        const DataColumn(label: const Expanded(
                          child: const Text(
                            'ID',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        ),
                        const DataColumn(label: const Expanded(
                          child: const Text(
                            'Title',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        ),
                          const DataColumn(label: const Expanded(
                        child: const Text(
                          'Active',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      ),
                      const DataColumn(label: const Expanded(
                        child: const Text(
                          'Image',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      ),
                    ], 
                    rows: result?.result.map((Event e) => DataRow(onSelectChanged: (value) => {
                      if(value == true){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EventDetailScreen(),
                            ),
                        )
                      }
                    },
                      cells: [
                        DataCell(Text(e.id?.toString() ?? "")),
                        DataCell(Text(e.title?.toString() ?? "")),
                        DataCell(Text(e.active?.toString() ?? "")),
                        DataCell(Container(
                          width: 100,
                          height: 100,
                          //child: imageFromBase64String(e.base64Data),
                          child: Flutter.Image.network(
                                e.firstImage?.filePath.toString() ?? "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png",
                                width: 200, // Set the desired width of the image
                                height: 200, // Set the desired height of the image
                              )
                        )),
                      ]
                    )
                    ).toList() ?? []
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton (
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
                      Text('Page $currentPage'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () async {
                          setState(() {
                            currentPage++;
                          });
                          await fetchData();
                          //print(currentPage);
                        },
                      ),
                    ],
                  )
                ],
              )
            )
          );
  }




}