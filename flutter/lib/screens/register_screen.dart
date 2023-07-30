import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../providers/login_provider.dart';
import '../providers/token_provider.dart';
import '../utils/util.dart';
import 'admin/dashboard_screen.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  late EventProvider _eventProvider;
  final loginProvider = LoginProvider();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _emailController.text = '';
    _usernameController.text = '';
    _passwordController.text = '';
    _eventProvider = context.read<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          //width: 400,
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
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
                                prefixIcon: Icon(Icons.people)),
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
                                labelText: "Email *",
                                prefixIcon: Icon(Icons.email)),
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Email';
                              }
                              const emailRegex =
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              if (!RegExp(emailRegex).hasMatch(value)) {
                                return 'Please enter a valid email address';
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
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Password';
                              }
                              return null; // Return null if the validation is successful
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "Re-enter Password *",
                                prefixIcon: Icon(Icons.password)),
                            controller: _repasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Re-enter a Password';
                              }
                              if (value != _passwordController.text) {
                                return 'Password does not match.';
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
                            var token = await registerButtonPressed(context);
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
                                        title: Text("Register Failed!"),
                                        content: Text(
                                            "User with email or username already exists."),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Ok"))
                                        ],
                                      ));
                            }
                          },
                          child: Text("Register"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> registerButtonPressed(BuildContext context) async {
    final username = _usernameController.text ?? "";
    final email = _emailController.text ?? "";
    final password = _passwordController.text ?? "";

    final token =
        await loginProvider.register(context, username, email, password);

    if (token != null) {
      return token;
    } else {
      print("Register failed");
      return null;
    }
  }
}
