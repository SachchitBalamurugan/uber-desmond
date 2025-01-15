import 'package:flutter/material.dart';

class Gym {
  final String name;
  final String address;
  final String imageUrl;

  Gym({
    required this.name,
    required this.address,
    required this.imageUrl,
  });
}

class GymProvider with ChangeNotifier {
  final List<Gym> _gyms = [
    Gym(
      name: 'Gym 1',
      address: 'Some address',
      imageUrl: 'https://via.placeholder.com/60', // Replace with actual URL
    ),
    Gym(
      name: 'Gym 2',
      address: 'Some address',
      imageUrl: 'https://via.placeholder.com/60',
    ),
    Gym(
      name: 'Gym 3',
      address: 'Some address',
      imageUrl: 'https://via.placeholder.com/60',
    ),
    Gym(
      name: 'Gym 4',
      address: 'Some address',
      imageUrl: 'https://via.placeholder.com/60',
    ),
    Gym(
      name: 'Gym 5',
      address: 'Some address',
      imageUrl: 'https://via.placeholder.com/60',
    ),
  ];

  List<Gym> get gyms => _gyms;
}