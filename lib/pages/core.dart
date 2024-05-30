import 'package:cars/themes/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cars/pages/widgets/home_activity.dart';
import 'package:cars/pages/widgets/profile_activity.dart';
import 'package:cars/pages/widgets/search_activity.dart';
import 'package:cars/pages/widgets/bookmarks_activity.dart';
import 'package:cars/themes/theme.dart';
import 'package:provider/provider.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeActivity(),
    const SearchActivity(),
    const BookmarksActivity(),
    const ProfileActivity(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            width: 0.4,
            color: Color.fromARGB(255, 87, 87, 87),
          )),
        ),
        child: ClipRRect(
          child: GNav(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            gap: 4,
            tabs: const [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.bookmark_outline_outlined, text: 'Bookmarks'),
              GButton(icon: Icons.person_outline_outlined, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
