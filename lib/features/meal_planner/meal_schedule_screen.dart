
import 'package:flutter/material.dart';

class MealScheduleScreen extends StatelessWidget {
  const MealScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Schedule'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Select Month & Year'),
            ),
            SizedBox(height: 16),
            buildDaysList(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildMealSection(
                    title: 'Breakfast',
                    subtitle: '2 meals | 230 calories',
                    items: [
                      MealItemInfo(title: 'Honey Pancake', subtitle: '07:00am'),
                      MealItemInfo(title: 'Omelette', subtitle: '07:30am'),
                    ],
                  ),
                  buildMealSection(
                    title: 'Lunch',
                    subtitle: '2 meals | 500 calories',
                    items: [
                      MealItemInfo(title: 'Chicken Salad', subtitle: '12:30pm'),
                      MealItemInfo(title: 'Pasta', subtitle: '01:00pm'),
                    ],
                  ),
                  buildMealSection(
                    title: 'Dinner',
                    subtitle: '2 meals | 600 calories',
                    items: [
                      MealItemInfo(title: 'Grilled Fish', subtitle: '07:30pm'),
                      MealItemInfo(title: 'Soup', subtitle: '08:00pm'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Today Meal Nutritions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  buildNutritionCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildDaysList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  'Day ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Mon'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMealSection({required String title, required String subtitle, required List<MealItemInfo> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 8),
        Column(
          children: items.map((item) => buildMealListTile(item)).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildMealListTile(MealItemInfo item) {
    return ListTile(
      leading: buildLeadingWidget(),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      trailing: buildTrailingWidget(),
    );
  }

  Widget buildLeadingWidget() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Placeholder(),
    );
  }

  Widget buildTrailingWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget buildNutritionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.place, color: Colors.purple),
                  SizedBox(width: 8),
                  Text('Total Calories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('320 kCal', style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8EB1BB),
                  Color(0xFF92A3FD),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('View Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Color(0xFF8EB1BB),
      child: Icon(Icons.add),

    );
  }
}

class MealItemInfo {
  final String title;
  final String subtitle;

  MealItemInfo({required this.title, required this.subtitle});
}
