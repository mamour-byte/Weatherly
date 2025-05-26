import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:weatherly/pages/HomePage.dart';
import 'package:weatherly/pages/Maps.dart';
import 'package:weatherly/pages/Search.dart';

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

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomePage(),
    SearchLocation(),
    Maps(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weatherly',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: CrystalNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          backgroundColor: Colors.white.withOpacity(0.2),
          indicatorColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.white,
          items:  [
            CrystalNavigationBarItem(
              icon: Icons.home,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: Icons.search,
              selectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: Icons.map_sharp,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
