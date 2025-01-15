import 'package:flutter/material.dart';
import 'package:healthapp/providers/user_info_provider.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_data_provider.dart';

class BMIUpdateDialog extends StatelessWidget {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  BMIUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update BMI'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _heightController,
            decoration: InputDecoration(labelText: 'Height (in cm)'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: TSizes.spaceBtwSections,),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(labelText: 'Weight (in kg)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog without updating
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Get the values from the controllers and update the provider
            final double height = double.tryParse(_heightController.text) ?? 0.0;
            final double weight = double.tryParse(_weightController.text) ?? 0.0;

            if (height > 0 && weight > 0) {
              // Update the user data in the provider
              Provider.of<UserProvider>(context, listen: false)
                  .updateUserData(weight, height);
              Provider.of<UserInfoModelProvider>(context,listen:  false).updateUserData(weight, height);

              // Close the dialog
              Navigator.of(context).pop();
            } else {
              // Show an error if height or weight is invalid
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please enter valid height and weight values'),
              ));
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}

