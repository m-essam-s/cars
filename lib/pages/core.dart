import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cars/pages/widgets/home_activity.dart';
import 'package:cars/pages/widgets/profile_activity.dart';
import 'package:cars/pages/widgets/search_activity.dart';
import 'package:cars/pages/widgets/bookmarks_activity.dart';
import 'package:cars/themes/theme_notifier.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeActivity(),
    SearchActivity(),
    BookmarksActivity(),
    ProfileActivity(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: GNav(
          backgroundColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
          color: isDarkMode ? Colors.white : Colors.black,
          activeColor: isDarkMode ? Colors.grey[300]! : Colors.grey[700]!,
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
    );
  }
}
