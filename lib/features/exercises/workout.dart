import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthapp/common/widgets/buttons/t_icon_button.dart';
import 'package:healthapp/features/exercises/video_screen.dart';
import 'package:healthapp/providers/workout_provider.dart';
import 'package:healthapp/services/workout_service.dart';
import 'package:healthapp/utils/constants/image_strings.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../home/workout_tracker.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});


  // void _markCompleted() async {
  //   // Get the current user
  //   final User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User not logged in.')),
  //     );
  //     return;
  //   }
  //
  //   final String userId = user.uid;
  //
  //   try {
  //     // Mark workout as completed and update the timestamp
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('complete')
  //         .add({
  //       'completed': true,
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'caloriesBurned': 250, // Calories burned
  //       'minutesWorkedOut': 25, // Minutes worked out
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Workout marked as completed!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to mark completed: $e')),
  //     );
  //     print('Error marking workout as completed: $e'); // Log the error here
  //   }
  // }
  //
  // DateTime? _selectedDate;
  // TimeOfDay? _selectedTime;
  //
  // void _scheduleWorkout() async {
  //   // Select the date
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(Duration(days: 365)),
  //   );
  //
  //   if (pickedDate != null) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   }
  //
  //   // Select the time
  //   TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     setState(() {
  //       _selectedTime = pickedTime;
  //     });
  //   }
  // }
  //
  // void _saveToFirebase() async {
  //   if (_selectedDate == null || _selectedTime == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select both date and time.')),
  //     );
  //     return;
  //   }
  //
  //   // Combine date and time into a DateTime object
  //   DateTime combinedDateTime = DateTime(
  //     _selectedDate!.year,
  //     _selectedDate!.month,
  //     _selectedDate!.day,
  //     _selectedTime!.hour,
  //     _selectedTime!.minute,
  //   );
  //
  //   // Format the date to the required format
  //   String formattedDate =
  //       "${combinedDateTime.month} ${combinedDateTime.day}, ${combinedDateTime.year} at ${combinedDateTime.hour}:${combinedDateTime.minute}:${combinedDateTime.second} ${combinedDateTime.hour >= 12 ? 'PM' : 'AM'} UTC-${combinedDateTime.timeZoneOffset.inHours}";
  //
  //   // Get the current user
  //   final User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User not logged in.')),
  //     );
  //     return;
  //   }
  //
  //   final String userId = user.uid;
  //
  //   try {
  //     // Save workout data under the user's document
  //     await FirebaseFirestore.instance
  //         .collection('users') // Users collection
  //         .doc(userId) // User document
  //         .collection(
  //             'workouts') // Workouts collection (this will be created dynamically)
  //         .add({
  //       'workout': 'Fullbody Workout',
  //       'date': formattedDate, // Save the formatted date
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Workout scheduled successfully!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save: $e')),
  //     );
  //     print('Error saving workout: $e'); // Log the error here
  //   }
  //
  //   print('User ID: $userId');
  //   print('Selected Date: $_selectedDate');
  //   print('Selected Time: $_selectedTime');
  //   print('Formatted Date: $formattedDate');
  // }

  @override
  Widget build(BuildContext context) {
    final workoutPro = Provider.of<WorkoutViewModel>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/Men-Vector.png',
                      height: 180,
                    ),
                  ),
                ),
                Positioned(
                  top: TSizes.defaultSpace,
                  left:  TSizes.defaultSpaceSm,
                  child:TIconButton(icon: Icons.arrow_back_ios_new, onPressed: ()=>Navigator.pop(context),shadowColor: Colors.grey,),
                ),
                Positioned(
                  top: TSizes.defaultSpace,
                  right:  TSizes.defaultSpaceSm,
                  child: IconButton(onPressed: (){}, icon: SvgPicture.asset(TSvgPath.favorite)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full body Workout',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1 Exercise | 25mins | 250 Calories Burnt',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:()=> workoutPro.setTimeAndDateForWorkout(context),
                          icon: Icon(Icons.calendar_today),
                          label: Text('Schedule Workout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF5F6FA),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE8F0FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Beginner'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: ()=>workoutPro.scheduleWorkout(context, 'full body workout'),
                    child: Text('Save to Firebase'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You\'ll Need',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildItem('Dumbbell'),
                      SizedBox(width: 16),
                      _buildItem('Skipping Rope'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Exercises',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildExerciseList(context),
                ],
              ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed:()=> workoutPro.markWorkoutAsCompletedAndMove(context, 'workoutId', 'scheduledDate'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     foregroundColor: Colors.white,
            //   ),
            //   child:const  Text('Completed'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.fitness_center),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    List<Map<String, String>> exercises = [
      {'name': 'Warm-up', 'time': '00:30', 'video': 'assets/warm_up.mp4'},
      {
        'name': 'Jumping Jack',
        'time': '1m',
        'video': 'assets/jumping_jack.mp4'
      },
      {'name': 'Skipping', 'time': '00:30', 'video': 'assets/skipping.mp4'},
      {'name': 'Squats', 'time': '00:30', 'video': 'assets/squats.mp4'},
      {'name': 'Arm Raises', 'time': '00:30', 'video': 'assets/arm_raises.mp4'},
      {
        'name': 'Incline Push-ups',
        'time': '00:30',
        'video': 'assets/incline_pushups.mp4'
      },
      {'name': 'Push-ups', 'time': '00:30', 'video': 'assets/pushups.mp4'},
    ];

    return Column(
      children: exercises.map((exercise) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  title: exercise['name']!,
                  videoPath: exercise['video']!,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF5F6FA),
                  child: Icon(Icons.play_arrow),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    exercise['name']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:healthapp/providers/workout_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../common/widgets/buttons/t_icon_button.dart';
// import '../../utils/constants/image_strings.dart';
// import '../../utils/constants/sizes.dart';
//
// class WorkoutScreen extends StatelessWidget {
//   const WorkoutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<WorkoutViewModel>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//
//             Stack(
//               children: [
//                 Container(
//                   height: 300,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFE8F0FE),
//                     borderRadius: BorderRadius.vertical(
//                       bottom: Radius.circular(30),
//                     ),
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       'assets/Men-Vector.png',
//                       height: 180,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: TSizes.defaultSpace,
//                   left: TSizes.defaultSpaceSm,
//                   child: TIconButton(
//                     icon: Icons.arrow_back_ios_new,
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//                 Positioned(
//                   top: TSizes.defaultSpace,
//                   right: TSizes.defaultSpaceSm,
//                   child: IconButton(
//                       onPressed: () {},
//                       icon: SvgPicture.asset(TSvgPath.favorite)),
//                 ),
//               ],
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title and Details
//                   Text(
//                     'Full Body Workout',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       viewModel.selectedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime.now().add(Duration(days: 365)),
//                       );
//                       viewModel.selectedTime = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.now(),
//                       );
//                       viewModel.scheduleWorkout(context, 'Full Body Workout');
//                     },
//                     icon: Icon(Icons.calendar_today),
//                     label: Text('Schedule Workout'),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => viewModel.markWorkoutAsCompleted(context),
//                     child: Text('Mark as Completed'),
//                   ),
//                   SizedBox(height: 16),
//                   // More UI...
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
