import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:f1_flutter/constants/colors.dart';
import 'package:f1_flutter/views/schedule/schedule.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'champions/champions.dart';
import 'fixture/fixture.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // Scaffold is a widget that implements the basic material design visual layout structure.
      body: Center(
        child: _currentIndex == 0
            ? const ChampionsScreen()
            : _currentIndex == 1
                ? const FixtureScreen()
                : const ScheduleScreen(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.primaryColorLight,
        backgroundColor: AppColors.white,
        items: const <Widget>[
          FaIcon(FontAwesomeIcons.trophy, size: 30),
          FaIcon(FontAwesomeIcons.listOl, size: 30),
          FaIcon(FontAwesomeIcons.calendarDays, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          //Handle button tap
        },
      ),
    );
  }
}
