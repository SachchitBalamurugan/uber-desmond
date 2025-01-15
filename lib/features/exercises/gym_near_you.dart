import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/gym_provider.dart';

class GymNearListScreen extends StatelessWidget {
  const GymNearListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gyms = context.watch<GymProvider>().gyms;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
        title: const Text(
          'Find Gyms Near You',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: gyms.length,
        itemBuilder: (context, index) {
          final gym = gyms[index];
          return GymListItem(gym: gym);
        },
      ),
    );
  }
}

class GymListItem extends StatelessWidget {
  final Gym gym;

  const GymListItem({required this.gym, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              gym.imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gym.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                gym.address,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }
}