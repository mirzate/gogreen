import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/screens/eco_violation_detail_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../providers/other_provider.dart';
import '../../../providers/user_provider.dart';
import 'package:flutter/material.dart' as Flutter;
import '../../../providers/token_provider.dart';
import 'user_edit_screen.dart';

class ManageUserListScreen extends StatefulWidget {
  const ManageUserListScreen({super.key});

  @override
  State<ManageUserListScreen> createState() => _ManageUserListScreenState();
}

class _ManageUserListScreenState extends State<ManageUserListScreen> {
  TextEditingController _fullTextSearchController = new TextEditingController();
  late UserProvider _UserProvider;
  late OtherProvider _otherProvider;
  SearchResult<User>? result;
  int currentPage = 1;
  int pageSize = 6;
  List<Municipality>? municipalities = [];
  Municipality? selectedMunicipality;
  //String? selectedMunicipality = null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _UserProvider = context.read<UserProvider>();
    _otherProvider = context.read<OtherProvider>();
    fetchMunicipalities();
  }

  Future<void> fetchMunicipalities() async {
    try {
      var data = await _UserProvider.getMunicipalities();
      setState(() {
        municipalities = data;
      });
      await fetchData();
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

  Future<void> fetchData() async {
    try {
      //_fullTextSearchController.clear(); // Da je potrebno obrisati

      var params = {
        "fullTextSearch": _fullTextSearchController.text,
        "pageIndex": currentPage,
        "pageSize": pageSize,
      };
      var data = await _UserProvider.getUsers(params: params);
      //print(data);

      setState(() {
        result = data;
      });
      //print("User result: $result");
      //print("User result?.result: ${result?.result}");
    } catch (error) {
      print(error.toString());
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

  Future<void> updateUserApprovalStatus(String userId, bool isApproved) async {
    print(userId);
    print(isApproved);

    await _UserProvider.approve(userId, isApproved);
    this.fetchData();
  }

  Future<void> updateUserMunicipality(User user) async {
    //print(user);

    await _UserProvider.updateMunicipality(user);
    this.fetchData();
  }

  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      title: "Manage users",
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
                    'Email',
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
                    'Approved',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: result?.result
                    .map((User e) => DataRow(
                            onSelectChanged: (value) => {
                                  if (value == true)
                                    {
                                      /*
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                             // UserEditScreen(ecoViolation: e),
                                        ),
                                      )
                                      */
                                    }
                                },
                            cells: [
                              DataCell(Text(e.id?.toString() ?? "")),
                              DataCell(Text(e.email?.toString() ?? "")),
                              DataCell(
                                DropdownButtonFormField<int>(
                                  value: e.municipality
                                      ?.id, // Use a default value if e.municipality is null
                                  items: municipalities?.map((municipality) {
                                    return DropdownMenuItem<int>(
                                      value: municipality.id,
                                      child: Text(municipality.title ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (selectedMunicipality) {
                                    setState(() {
                                      e.municipality?.id = selectedMunicipality;
                                      updateUserMunicipality(e);
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                Checkbox(
                                  value: e.isApproved ?? false,
                                  onChanged: (bool? value) {
                                    // Call your method here to update the approval status
                                    if (value != null) {
                                      setState(() {
                                        e.isApproved = value;
                                      });
                                      // Call your update method here
                                      updateUserApprovalStatus(e.id!, value);
                                    }
                                  },
                                ),
                              ),
                            ]))
                    .toList() ??
                []),
      ],
    )));
  }
}
