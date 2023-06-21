import 'package:flutter/material.dart';
import 'package:gogreen/providers/event_provider.dart';
import 'package:gogreen/utils/util.dart';
import 'package:provider/provider.dart';

import 'screens/event_list_screen.dart';

void main() {
  //runApp(const MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => EventProvider())
    ],
    child: const GoGreenApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGreen',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: GoGreenApp(), //const MyHomePage(title: 'Flutter Demo Home Page MT 1'),
    );
  }
}

class GoGreenApp extends StatelessWidget {
  const GoGreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GoGreen",
      theme: ThemeData(
        primaryColor: Colors.lightGreen
        ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late EventProvider _eventProvider;

  @override
  Widget build(BuildContext context) {
  
    _usernameController.text = "test";
    _passwordController.text = 'Password1\$';
    _eventProvider = context.read<EventProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text("Login"), backgroundColor: Theme.of(context).primaryColor,),
      body: Center(
        child: Container(
          //width: 400,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 400
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset('assets/images/gogreen-logo.png',width: 100,height: 100,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.email)
                    ),
                    controller: _usernameController,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password)
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      
                      Authorization.username = username;
                      Authorization.password = password;

                      try {
                        //await _eventProvider.get();
                        //await _eventProvider.get(pageIndex: 1, pageSize: 10);
                        // Loading data moved on init of event list with pagination
                        
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EventListScreen(),
                            ),
                        );
                      } on Exception catch (e) {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(onPressed: ()=> Navigator.pop(context), child: Text("Ok"))
                            ],
                        ));
                      }
                    },
                    child: Text("Login"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                  ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

