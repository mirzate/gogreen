import 'package:flutter/material.dart';
import 'package:gogreen/providers/eco_violation_provider.dart';
import 'package:gogreen/providers/event_provider.dart';
import 'package:gogreen/providers/login_provider.dart';
import 'package:gogreen/providers/green_island_provider.dart';
import 'package:gogreen/providers/other_provider.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/providers/user_provider.dart';
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
    ChangeNotifierProvider(create: (_) => OtherProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
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
