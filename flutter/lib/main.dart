import 'package:flutter/material.dart';

import 'screens/event_list_screen.dart';

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
/*
class MyWidget extends StatelessWidget {
  String? title;
  MyWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
   return Text(title!);
  }
}
*/
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {

  int _count = 0;

  void _incCounter(){
    setState(() {
      _count++;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("You have pushed $_count times"),
        ElevatedButton(onPressed: _incCounter, child: const Text("Increment ++"))
      ],
    );
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          color: Colors.yellow,
          child: Center(
          child: Container(
            height: 100,
            color: Colors.grey,
            child: Text("test"),
            //alignment: Alignment.center,
          ),
        ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Row 1"),
            Text("Row 2"),
            Text("Row 3")
          ],
        ),
        Container(
          height: 200,
          color: Colors.amberAccent,
          child: Text("test"),
          alignment: Alignment.center,
        )

      ],
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
  
  @override
  Widget build(BuildContext context) {
  _usernameController.text = "test";
  _passwordController.text = 'Password1\$';
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
                    onPressed: () {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventListScreen(),
                          ),
                      );
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
