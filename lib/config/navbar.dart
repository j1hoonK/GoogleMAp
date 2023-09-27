import 'package:flutter/material.dart';

import '../view/google_map.dart';
import '../view/location_test.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => setState(() {
          _currentIndex = value;
        }),
        animationDuration: Duration(milliseconds: 2000),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'GoogleMap',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            label: 'LocationTest',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          GoogleMapApp(),
          OrderTrackingPage(),
        ],
      ),
    );
  }
}
