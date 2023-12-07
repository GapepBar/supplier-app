import 'package:flutter/material.dart';

import '../Widgets/homepage/orders.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    print(index);
    if (index < 1) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 1) {
      print('profile');
      Navigator.of(context).pushNamed('/profilepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      OrderWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gappebar'),
      ),
      body: _selectedIndex < 1
          ? _widgetOptions.elementAt(_selectedIndex)
          : Center(
              child: Text('Inside Black Hole'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber[800],
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
