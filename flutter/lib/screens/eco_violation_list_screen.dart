import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/eco_violation_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../models/eco_violation.dart';
import '../providers/eco_violation_provider.dart';
import 'package:flutter/material.dart' as Flutter;

import '../providers/token_provider.dart';
import 'eco_violation_add_screen.dart';

class EcoViolationListScreen extends StatefulWidget {
  const EcoViolationListScreen({super.key});

  @override
  State<EcoViolationListScreen> createState() => _EcoViolationListScreenState();
}

class _EcoViolationListScreenState extends State<EcoViolationListScreen> {
  TextEditingController _fullTextSearchController = new TextEditingController();
  late EcoViolationProvider _EcoViolationProvider;
  SearchResult<Ecoviolation>? result;
  int currentPage = 1;
  int pageSize = 6;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _EcoViolationProvider = context.read<EcoViolationProvider>();
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
      var data = await _EcoViolationProvider.get(params: params);
      setState(() {
        result = data as SearchResult<Ecoviolation>?;
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
      title: "Eco-Violations",
      child: Scaffold(
        // Wrap the entire content with Scaffold
        body: Container(
          child: Column(
            children: [
              _buildSearch(),
              _buildDataListView(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EcoViolationAddScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightGreenAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    'Title',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'Municipality',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: const Expanded(
                  child: const Text(
                    'Status',
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
            rows: result?.result
                    .map((Ecoviolation e) => DataRow(
                            onSelectChanged: (value) => {
                                  if (value == true)
                                    {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EcoViolationDetailScreen(
                                                  Ecoviolation: e),
                                        ),
                                      )
                                    }
                                },
                            cells: [
                              DataCell(Text(e.title?.toString() ?? "")),
                              DataCell(
                                  Text(e.municipality?.title.toString() ?? "")),
                              DataCell(Text(
                                  e.ecoViolationStatus?.name.toString() ??
                                      "N/A")),
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
