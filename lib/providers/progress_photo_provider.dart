import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressPhotoProvider with ChangeNotifier {
  final List<String> _imagePaths = [];

  List<String> get imagePaths => _imagePaths;

  ProgressPhotoProvider() {
    fetchImages();
  }

  Future<void> fetchImages() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        DatabaseReference progressPhotosRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child('progressPhotos');

        DatabaseEvent event = await progressPhotosRef.once();
        final data = event.snapshot.value as List?;
        if (data != null) {
          _imagePaths.clear();
          _imagePaths.addAll(data.cast<String>());
          notifyListeners();
        }
      } catch (e) {
        print("Error fetching images: $e");
      }
    }
  }

  Future<void> uploadPhoto(File photo) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user.uid;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('progressPhotos/$userId/$fileName');

        // Upload photo to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(photo);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Realtime Database
        DatabaseReference progressPhotosRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child('progressPhotos');

        DatabaseEvent event = await progressPhotosRef.once();
        List<String> currentPhotos =
            (event.snapshot.value as List?)?.cast<String>() ?? [];
        currentPhotos.add(downloadUrl);
        await progressPhotosRef.set(currentPhotos);

        _imagePaths.add(downloadUrl);
        notifyListeners();
      } catch (e) {
        print("Error uploading photo: $e");
      }
    }
  }
  // This function is part of the ProgressPhotoProvider class
  Future<void> saveImage(File photo) async {
    try {
      // Get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'progress_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await photo.copy('${appDir.path}/$fileName');

      _imagePaths.add(savedImage.path);

      // Save the updated list to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('progress_photos', json.encode(_imagePaths));

      notifyListeners();
    } catch (e) {
      print("Error saving image: $e");
    }
  }
}
