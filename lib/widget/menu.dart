import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uas_project/auth/firebase_auth_services.dart';
import 'package:uas_project/tabs/home.dart';
import 'package:uas_project/tabs/food.dart';
import 'package:uas_project/tabs/login.dart';
import 'package:uas_project/tabs/cart.dart';
import 'package:uas_project/tabs/profile.dart';

class MenuScreen extends StatefulWidget {
  final int currentIndex;
  MenuScreen({this.currentIndex = 0});
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  int _currentIndex = 0;

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _updateTabs();
    _currentIndex = widget.currentIndex;
  }

  void _updateTabs() async {
    User? user = await _auth.getCurrentUser();

    setState(() {
      _tabs = [
        HomeTab(user: user, isUserLoggedIn: user != null),
        FoodTab(),
        CartTab(),
        ProfileTab(user: user, onLogout: _updateTabsAfterSignOut, isUserLoggedIn: user != null),
        LoginTab(),
      ];
    });

    if (_currentIndex < 0 || _currentIndex >= _tabs.length) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }
  void _updateTabsAfterSignOut() {
    setState(() {
      _tabs = [
        HomeTab(),
        FoodTab(),
        CartTab(),
        LoginTab(),
      ];
    });

    if (_currentIndex < 0 || _currentIndex >= _tabs.length) {
      setState(() {
        _currentIndex = 0;
      });
    }}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 226, 100, 124),
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.hamburger,
                text: 'Food',
              ),
              GButton(
                icon: LineIcons.shoppingCart,
                text: 'Cart',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profil',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
