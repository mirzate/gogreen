import 'package:gogreen/models/green_island.dart';
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/admin/green_island/green_island_edit_screen.dart';
import 'package:gogreen/screens/event_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../../../models/green_island.dart';
import '../../../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import '../../../providers/token_provider.dart';

class ManageGreenIslandListScreen extends StatefulWidget {
  const ManageGreenIslandListScreen({super.key});

  @override
  State<ManageGreenIslandListScreen> createState() =>
      _ManageGreenIslandListScreenState();

  fetchData() {}
}

class _ManageGreenIslandListScreenState
    extends State<ManageGreenIslandListScreen> {
  TextEditingController _fullTextSearchController = new TextEditingController();
  late GreenIslandProvider _greenIslandProvider;
  SearchResult<GreenIsland>? result;
  int currentPage = 1;
  int pageSize = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _greenIslandProvider = context.read<GreenIslandProvider>();
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
      print("fetchData");
      print(params);
      var data = await _greenIslandProvider.get(params: params);
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

  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      title: "Manage Green Islands",
      child: Container(
        child: Column(
          children: [_buildSearch(), _buildDataListView()],
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
          SizedBox(
            height: 10,
          ),
          /*
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
              */
          /*
              ElevatedButton(
                onPressed: () async {
                  var data = await _greenIslandProvider.get(params: {
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
        ],
      ),
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
                    'Edit',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: result?.result
                    .map((GreenIsland e) => DataRow(
                            onSelectChanged: (value) => {if (value == true) {}},
                            cells: [
                              DataCell(Text(e.id?.toString() ?? "")),
                              DataCell(Text(e.title?.toString() ?? "")),
                              DataCell(IconButton(
                                icon: Icon(Icons.edit),
                                iconSize: 16,
                                onPressed: () {
                                  // Add your button onPressed logic here
                                  // This function will be called when the button is pressed
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GreenIslandEditScreen(greenIsland: e),
                                    ),
                                  );
                                },
                              )),
                            ]))
                    .toList() ??
                []),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: (result?.pageIndex ?? 0) != 1,
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
              visible: currentPage < (result?.totalPages ?? 0),
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
