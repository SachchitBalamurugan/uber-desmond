import 'package:flutter/material.dart';
import 'package:healthapp/features/home/workout_tracker.dart';
import 'package:healthapp/features/home/profile.dart';
import 'package:healthapp/features/home/home.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:healthapp/features/home/sleep_tracker.dart';
import 'package:healthapp/features/progress_result/result_screen.dart';
import 'package:healthapp/providers/home_provider.dart';
import 'package:healthapp/providers/user_data_provider.dart';
import 'package:healthapp/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_data_provider.dart';
import '../../providers/workout_provider.dart';

class TBottomNavigationBar extends StatelessWidget {
 List<Widget> screens = [
    HomeScreen(),
    SleepTrackerScreen(),
    WorkoutTrackerScreen(),
    ResultScreen(),
    ProfileScreen(),
  ];
  List<IconData> iconList = [
    Iconsax.home,
    Iconsax.clock,
    Iconsax.graph,
    Iconsax.camera,
    Iconsax.profile_circle,
  ];

  TBottomNavigationBar({super.key});




  @override
  Widget build(BuildContext context) {
    Future<void> fetchProviders() async {
      await Provider.of<WorkoutViewModel>(context, listen: false).fetchWorkouts();
      await Provider.of<UserProvider>(context, listen: false).fetchUserData();
      await Provider.of<WorkoutDataProvider>(context, listen: false).fetchWorkoutData(context);
    }

    Future<void> _onRefresh() async {
      // Fetch updated data
      await fetchProviders();
      // Additional logic if needed
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: screens.elementAt(homeProvider.screenIndex),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: TColors.primary,
        elevation: 4,
        icons: iconList,
        activeIndex: homeProvider.screenIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          fetchProviders();
          homeProvider.jumpToScreen(index);
        },
        // other params
      ),
    );
  }
}
