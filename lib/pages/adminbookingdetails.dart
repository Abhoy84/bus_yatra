import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ticketbooking/pages/downbooking.dart';
import 'package:ticketbooking/pages/upbooking.dart';

class bookingdtails extends StatefulWidget {
  const bookingdtails({super.key});

  @override
  State<bookingdtails> createState() => bookingdtailsState();
}

class bookingdtailsState extends State<bookingdtails> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const upbooking(),
    const downbooking(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'UP to DOWN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward),
            label: 'DOWN to UP',
          ),
        ],
      ),
    );
  }
}
