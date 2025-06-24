import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eventbooking/pages/booking.dart';
import 'package:eventbooking/pages/home.dart';
import 'package:eventbooking/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late ProfilePage profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    home = Home();
    booking = Booking();
    profile = ProfilePage(
      userName: "Raxit Gondaliya",
      userEmail: "raxitgondaliya@gmail.com",
      profileImageUrl: "https://www.w3schools.com/howto/img_avatar.png",
    );
    pages = [home, booking, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentTabIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(milliseconds: 300),
          index: currentTabIndex,
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(Icons.home_outlined, color: Colors.white, size: 30.0),
            Icon(Icons.book, color: Colors.white, size: 30.0),
            Icon(Icons.person_outline, color: Colors.white, size: 30.0),
          ],
        ),
      ),
    );
  }
}
