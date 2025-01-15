import 'package:flutter/material.dart';

class DisplayTitleMd extends StatelessWidget {
  const DisplayTitleMd({
    super.key, required this.title,  this.color
  });
  final String title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,

      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
    );
  }
}