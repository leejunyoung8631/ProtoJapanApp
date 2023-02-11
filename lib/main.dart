// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'home.dart';
import 'restaurant.dart';
import 'g_map.dart';
import 'attraction.dart';
import 'tips.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // for apikey

void main() async {
  // add firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo version',
      theme: ThemeData(
        primarySwatch: Colors.blue, // color of toolbar
      ),
      home: const MainPage(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// BottomNavigationBar

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo_app'),
      ),
      body: HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "restaurant",
            icon: Icon(Icons.restaurant_menu_sharp),
          ),
          BottomNavigationBarItem(
            label: "map",
            icon: Icon(Icons.map_rounded),
          ),
          BottomNavigationBarItem(
            label: "attraction",
            icon: Icon(Icons.star),
          ),
          BottomNavigationBarItem(
              label: "tips", icon: Icon(Icons.tips_and_updates)),
        ],
      ),
    );
  }
}

// just scratch code for reference

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // It holds the values provided by the parent (in this case the title).
  // and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // it rerun the build method below so that the display can reflect the updated values.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    // The Flutter framework has been optimized to make rerunning build methods fast.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
