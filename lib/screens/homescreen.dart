import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/homewidget.dart';
import 'widgets/playlistwidget.dart';
import 'widgets/trendingwidget.dart';


class homeScreen extends StatefulWidget {
  static const String id = "homescreen";
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetoptions=[homewidget(),trendingwidget(),playlistwidget()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       _widgetoptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined, color: Colors.white),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.music, color: Colors.white),
            label: 'PlayList',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}