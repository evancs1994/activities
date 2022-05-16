import 'package:activities/ui/home.dart';
import 'package:activities/ui/my_activity.dart';
import 'package:activities/ui/order.dart';
import 'package:activities/ui/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key key}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int selectedIndex = 0;
  Widget _currBody = const HomePage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onTap(int index) {
    switch (index) {
      case 0:
        setState(() {
          _currBody = const HomePage();
          selectedIndex = index;
        });
        break;
      case 1:
        setState(() {
          _currBody = const MyActivityPage();
          selectedIndex = index;
        });
        break;
      case 2:
        setState(() {
          _currBody = const OrderPage();
          selectedIndex = index;
        });
        break;

      case 3:
        setState(() {
          _currBody = const Profile();
          selectedIndex = index;
        });
        break;
    }
  }

  Widget bottomNavBar() => Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          shape: BoxShape.rectangle,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.blue[900],
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.blueGrey[400]),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 20),
          unselectedIconTheme: const IconThemeData(size: 18),
          currentIndex: selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'My Activity', icon: Icon(Icons.calendar_month)),
            BottomNavigationBarItem(
                label: 'Order', icon: Icon(Icons.perm_identity)),
            BottomNavigationBarItem(
                label: 'My Profile', icon: Icon(Icons.person)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _currBody,
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }
}
