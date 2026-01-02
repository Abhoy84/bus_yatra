import 'package:flutter/src/widgets/framework.dart';
import "package:flutter/material.dart";

import 'package:ticketbooking/pages/cancelledTicketlist.dart';

import 'package:ticketbooking/pages/bookedTicketlist.dart';
import 'package:ticketbooking/pages/userhistory.dart';

class alltickets extends StatefulWidget {
  const alltickets({super.key});

  @override
  _allticketsState createState() => _allticketsState();
}

class _allticketsState extends State<alltickets> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const bookedticketlist(),
    const cancelledticketlist(),
    const historyticketlist()
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
            icon: Icon(Icons.assignment_turned_in),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.block_flipped),
            label: 'Cancelled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
