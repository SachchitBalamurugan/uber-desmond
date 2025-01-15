import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/add_alarm_provider.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddAlarmProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          centerTitle: true,
          title: const Text(
            "Add Alarm",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<AddAlarmProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  DropdownTile(
                    title: "Bedtime",
                    value: provider.selectedBedtime,
                    items: provider.bedtimes,
                    onChanged: (value) => provider.setBedtime(value!),
                  ),
                  DropdownTile(
                    title: "Hours of sleep",
                    value: provider.selectedSleepHours,
                    items: provider.sleepHours,
                    onChanged: (value) => provider.setSleepHours(value!),
                  ),
                  MultiSelectTile(
                    title: "Repeat",
                    selectedItems: provider.selectedDays,
                    items: provider.weekdays,
                    onChanged: provider.setRepeatDays,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.vibration, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            "Vibrate When Alarm Sound",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Switch(
                        value: provider.vibrate,
                        onChanged: provider.toggleVibrate,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (provider.loading)
                    const CircularProgressIndicator()
                  else
                    GradientButton(
                      text: "Save",
                      onPressed: () => provider.saveAlarmToFirebase(context),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



class DropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  DropdownTile({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.bed, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          DropdownButton<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class MultiSelectTile extends StatelessWidget {
  final String title;
  final List<String> selectedItems;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  MultiSelectTile({
    required this.title,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Wrap(
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return GestureDetector(
              onTap: () {
                final updatedItems = [...selectedItems];
                if (isSelected) {
                  updatedItems.remove(item);
                } else {
                  updatedItems.add(item);
                }
                onChanged(updatedItems);
              },
              child: Chip(
                label: Text(item),
                backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
