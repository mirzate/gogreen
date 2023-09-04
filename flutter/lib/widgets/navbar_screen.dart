import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gogreen/screens/eco_violation_list_screen.dart';
import 'package:gogreen/screens/green_island_map_screen.dart';
import 'package:gogreen/screens/super_admin/user/user_list_screen.dart';
import 'package:provider/provider.dart';
import '../screens/green_island_map_screen.dart';
import '../screens/admin/dashboard_screen.dart';
import '../screens/event_list_screen.dart';
import '../main.dart';
import '../screens/login_screen.dart';
import '../utils/util.dart';
import '../providers/login_provider.dart';

class NavbarScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;

  NavbarScreenWidget({this.child, this.title, super.key});

  @override
  State<NavbarScreenWidget> createState() => _NavbarScreenWidgetState();
}

class _NavbarScreenWidgetState extends State<NavbarScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: widget.child,
        drawer: Drawer(
            child: Consumer<LoginProvider>(builder: (context, login, child) {
          return ListView(
            children: [
              //Text(login.isLoggedIn.toString()),
              ListTile(
                title: Text('Back'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
              ),
              if (Authorization.token == null)
                Column(
                  children: [
                    Divider(),
                    ListTile(
                      title: Text("Events"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventListScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text("Eco-Violations"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const EcoViolationListScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text("Green Islands Map"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GreenIslandMapScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Municipality Admin Panel",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                },
                enabled: Authorization.token != null,
              ),
              if (Authorization.token == null)
                ListTile(
                  title: Text('Login'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  enabled: Authorization.token == null,
                ),
              if (Authorization.token != null)
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    Authorization.token = null;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EventListScreen(),
                      ),
                    );
                  },
                  enabled: Authorization.token != null,
                ),
            ],
          );
        })));
  }
}
