import 'package:gogreen/screens/admin/violation/eco_violation_list_screen.dart';
import 'package:gogreen/screens/admin/event/event_list_screen.dart';
import 'package:gogreen/screens/admin/green_island/green_island_list_screen.dart';
import 'package:gogreen/widgets/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../../providers/login_provider.dart';
import '../../../models/user.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen();
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late LoginProvider _loginProvider;
  User user = User();
  Key navbarKey = UniqueKey();

  @override
  void initState() {
    _loginProvider = LoginProvider();
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return NavbarScreenWidget(
      key: navbarKey,
      title:
          "Municipality Dashboards | ${user?.municipality?.title ?? ''} | ${user.email ?? ''}",
      child: Scaffold(
        // Wrap the entire content with Scaffold
        body: Container(
          child: Column(
            children: [_content()],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUser() async {
    try {
      var data = await _loginProvider.getUser();
      setState(() {
        user = data!;
        navbarKey = UniqueKey();
      });
    } catch (error) {
      print(error);
    }
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Add your onPressed logic here
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageEventListScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.list), // Add your desired icon
                          label: Text(
                              'Manage Events'), // Add your desired label or text
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Add your onPressed logic here
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageEcoViolationListScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.info), // Add your desired icon
                          label: Text(
                              'Manage Eco Violations'), // Add your desired label or text
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Add your onPressed logic here
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageGreenIslandListScreen(),
                              ),
                            );
                          },
                          icon:
                              Icon(Icons.map_rounded), // Add your desired icon
                          label: Text(
                              'Manage Green Islands'), // Add your desired label or text
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
