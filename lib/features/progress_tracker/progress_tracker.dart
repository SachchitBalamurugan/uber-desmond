import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/progress_photo_provider.dart';
import '../../utils/constants/colors.dart';

class ProgressPhotoScreen extends StatelessWidget {
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Progress Photo',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: TColors.white,
                      radius: 30,
                      child: SvgPicture.asset(
                        TSvgPath.remindersCalender,
                        height: 38,
                      )
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Reminder!\n',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: 'Next Photos Fall On July 08',
                            style: TextStyle(
                              color: TColors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.close, color: TColors.darkGrey),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Track Your Progress Each Month With ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Photo',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF9DCEFF)
                          ),
                          onPressed: () {},
                          child: Text(
                            'Learn More',
                            style: TextStyle(color: TColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(TSvgPath.markingCalender),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Compare my Photo',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Compare',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See more',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            //TODO just for now i offed it
            // Expanded(
            //   child: Consumer<ProgressPhotoProvider>(
            //     builder: (context, provider, child) {
            //       if (provider.imagePaths.isEmpty) {
            //         return Center(child: Text('No photos yet.'));
            //       }
            //       return GridView.builder(
            //         itemCount: provider.imagePaths.length,
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 3,
            //           crossAxisSpacing: 8,
            //           mainAxisSpacing: 8,
            //         ),
            //         itemBuilder: (context, index) {
            //           return ClipRRect(
            //             borderRadius: BorderRadius.circular(8.0),
            //             child: Image.file(
            //               File(provider.imagePaths[index]),
            //               fit: BoxFit.cover,
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: TColors.primary,
          onPressed: () => _captureAndSavePhoto(context),
          child: Icon(
            Iconsax.camera,
            color: TColors.white,
          )
      ),
    );
  }

  Future<void> _captureAndSavePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File photo = File(pickedFile.path);
     final provider =  Provider.of<ProgressPhotoProvider>(context, listen: false);
          provider.saveImage(photo);
    }
  }
}