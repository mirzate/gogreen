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

  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      title: "GreenIsland List",
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
        ],
      ),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(children: [
      Text("Google map implete here"),
    ])));
  }
}
