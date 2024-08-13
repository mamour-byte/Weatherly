import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/pages/HomePage.dart';
import 'package:weatherly/pages/Maps.dart';
import 'package:weatherly/pages/Search.dart';
import 'package:weatherly/Theme/Theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  SetCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background ,
        body: [
          const HomePage(),
          const SearchLocation(),
          const Maps(),
        ][_currentIndex],

        bottomNavigationBar: CrystalNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black.withOpacity(0.1),
          indicatorColor: Colors.black,
          unselectedItemColor: const Color(0xff757575),
          onTap: (i) => setState(() => _currentIndex = i),
          items: [

            CrystalNavigationBarItem(
              icon: Icons.home,
              selectedColor: Colors.black,
            ),
            CrystalNavigationBarItem(
              icon: Icons.search,
              selectedColor: Colors.black,
            ),
            CrystalNavigationBarItem(
              icon: Icons.map_sharp,
              selectedColor: Colors.black,
            ),
          ],
        ),

      ),
    );

  }
}