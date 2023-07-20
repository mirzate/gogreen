import 'package:flutter/material.dart';
import 'package:gogreen/providers/eco_violation_provider.dart';
import 'package:gogreen/providers/event_provider.dart';
import 'package:gogreen/providers/login_provider.dart';
import 'package:gogreen/providers/green_island_provider.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/screens/admin/dashboard_screen.dart';
import 'package:gogreen/utils/util.dart';
import 'package:provider/provider.dart';

import 'screens/event_list_screen.dart';

void main() {
  //runApp(const MyApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EventProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => TokenProvider()),
    ChangeNotifierProvider(create: (_) => EcoViolationProvider()),
    ChangeNotifierProvider(create: (_) => GreenIslandProvider()),
  ], child: const GoGreenApp()));
}

class GoGreenApp extends StatelessWidget {
  const GoGreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GoGreen",
      theme: ThemeData(primaryColor: Colors.lightGreen),
      home: const EventListScreen(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late EventProvider _eventProvider;
  final loginProvider = LoginProvider();

  @override
  Widget build(BuildContext context) {
    _usernameController.text = '';
    _passwordController.text = '';
    _eventProvider = context.read<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          //width: 400,
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/gogreen-logo.png',
                    width: 100,
                    height: 100,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Username", prefixIcon: Icon(Icons.email)),
                    controller: _usernameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password)),
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;

                      Authorization.username = username;
                      Authorization.password = password;
                      var token = await loginButtonPressed();
                      Authorization.token = token as String?;

                      // Set token in TokenProvider to have option to access via provider to. (var token = tokenProvider.token;)
                      final tokenProvider =
                          Provider.of<TokenProvider>(context, listen: false);
                      tokenProvider.setToken(token as String?);

                      if (token != null) {
                        try {
                          //await _eventProvider.get();
                          //await _eventProvider.get(pageIndex: 1, pageSize: 10);
                          // Loading data moved on init of event list with pagination

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Ok"))
                                    ],
                                  ));
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Login Failed!"),
                                  content:
                                      Text("Wrong username or password..."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Ok"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Login"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> loginButtonPressed() async {
    final username = Authorization.username ?? "";
    final password = Authorization.password ?? "";

    final token = await loginProvider.login(username, password);

    if (token != null) {
      return token;
    } else {
      print("Login failed");
      return null;
    }
  }
}
