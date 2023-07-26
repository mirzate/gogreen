import 'package:flutter/material.dart';
import 'package:gogreen/screens/register_screen.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../providers/login_provider.dart';
import '../providers/token_provider.dart';
import '../utils/util.dart';
import 'admin/dashboard_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late EventProvider _eventProvider;
  final loginProvider = LoginProvider();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "Username *",
                                prefixIcon: Icon(Icons.email)),
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Username';
                              }
                              return null; // Return null if the validation is successful
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "Password *",
                                prefixIcon: Icon(Icons.password)),
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Password';
                              }
                              return null; // Return null if the validation is successful
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            var username = _usernameController.text;
                            var password = _passwordController.text;

                            Authorization.username = username;
                            Authorization.password = password;
                            var token = await loginButtonPressed();
                            Authorization.token = token as String?;

                            // Set token in TokenProvider to have option to access via provider to. (var token = tokenProvider.token;)
                            final tokenProvider = Provider.of<TokenProvider>(
                                context,
                                listen: false);
                            tokenProvider.setToken(token as String?);

                            if (token != null) {
                              try {
                                //await _eventProvider.get();
                                //await _eventProvider.get(pageIndex: 1, pageSize: 10);
                                // Loading data moved on init of event list with pagination

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(),
                                  ),
                                );
                              } on Exception catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Login Failed!"),
                                        content: Text(
                                            "Wrong username or password..."),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
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
                        ),
                      ])),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "If you don't have account already, please click on Register button.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[
                                      600]!), // Change to dark yellow color
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8), // Adjust the button size
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Add bold font style to the text
                                fontSize:
                                    12, // Change the font size of the text
                                color: Colors
                                    .white, // Change the text color to white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
