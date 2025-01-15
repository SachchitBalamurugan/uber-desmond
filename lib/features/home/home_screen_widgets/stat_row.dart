import 'package:flutter/cupertino.dart';
import 'package:healthapp/features/home/home_screen_widgets/stat_card.dart';

import '../../exercises/steps_screen.dart';

class StatsRow extends StatelessWidget {
  final int calories;
  final int minutes;

  const StatsRow({
    Key? key,
    required this.calories,
    required this.minutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatCard(
          title: '$calories',
          subtitle: 'Calories\nburned',
        ),
        StatCard(
          title: '$minutes',
          subtitle: 'minutes',
        ),
      ],
    );
  }
}