
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/eco_violation_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../models/green_island.dart';
import '../providers/green_island_provider.dart';
import 'package:flutter/material.dart' as Flutter;

import '../providers/token_provider.dart';


class GreenIslandListScreen extends StatefulWidget {
  const GreenIslandListScreen({super.key});

  @override
  State<GreenIslandListScreen> createState() => _GreenIslandListScreenState();
}

class _GreenIslandListScreenState extends State<GreenIslandListScreen> {

  TextEditingController _fullTextSearchController = new TextEditingController();
  late GreenIslandProvider _GreenIslandProvider;
  SearchResult<GreenIsland>? result;
  int currentPage = 1;
  int pageSize = 6;

  @override
  void didChangeDependencies(){
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
      var data = await _GreenIslandProvider.get(
        params: params
      );
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
            TextButton(onPressed: ()=> Navigator.pop(context), child: Text("Ok"))
          ],
      ));

    }
  }

  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      title: "GreenIsland List",
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
              SizedBox(height: 10,),
      ],),
    );
  }
  
  Expanded _buildDataListView() {
    return Expanded(child: 
            SingleChildScrollView(child: 
              Column(
                children: [
                  DataTable(
                    showCheckboxColumn: false,
                    columns: [
                        DataColumn(label: const Expanded(
                            child: const Text(
                              'ID',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(label: const Expanded(
                            child: const Text(
                              'Title',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(label: const Expanded(
                          child: const Text(
                            'Municipality',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          ),
                        ),
                        DataColumn(label: const Expanded(
                            child: const Text(
                              'Image',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                    ], 
                    rows: result?.result.map((GreenIsland e) => 
                      DataRow(
                        onSelectChanged: (value) => {
                          if(value == true){
                            
                          }
                        },
                        cells: [
                          DataCell(Text(e.id?.toString() ?? "")),
                          DataCell(Text(e.title?.toString() ?? "")),
                          DataCell(Text(e.municipality?.title.toString() ?? "")),
                          DataCell(Container(
                            width: 80,
                            height: 80,
                            child: Flutter.Image.network(
                                  e.firstImage?.filePath.toString() ?? "https://upload.wikimedia.org/wikipedia/commons/f/fc/Gogreen.png",
                                  //width: 200, // Set the desired width of the image
                                  //height: 200, // Set the desired height of the image
                                )
                          )),
                        ]
                      )
                    ).toList() ?? []
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: (result?.pageIndex ?? 0) != 1,
                        child: IconButton (
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
              )
            )
          );
  }


}