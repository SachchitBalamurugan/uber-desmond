// result_screen.dart
import 'package:flutter/material.dart';
import 'package:healthapp/common/widgets/appbar/t_app_bar.dart';
import 'package:healthapp/utils/constants/sizes.dart';
import 'package:healthapp/utils/devices/device_utility.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../model/user_info.dart';
import '../../providers/user_info_provider.dart';
import '../home/widget/bmi_update_dialog.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = 'CURRENT_USER_UID'; // Replace with actual user UID

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: TSizes.spaceBtwSections,),
          TAppBar(titleWidget: Text("Results",style: Theme.of(context).textTheme.titleLarge,), shadowColorLeading: Colors.grey.shade200,shadowColorTrailing: Colors.grey.shade200,titleTrue: true,),

          StreamBuilder<Map<String, UserInfoModel>>(
            stream: context.read<UserInfoModelProvider>().getUserInfoModelStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Error loading data'));
              }

              final previousInfo = snapshot.data!['previous']!;
              final currentInfo = snapshot.data!['current']!;

              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStatusCard(context, previousInfo, currentInfo),
                      const SizedBox(height: 20),
                      _buildProgressChart(),
                      const SizedBox(height: 20),
                      _buildComparisonBars(previousInfo, currentInfo),
                      const SizedBox(height: 20),
                      _buildUpdateButton(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, UserInfoModel previous, UserInfoModel current) {
    final provider = context.read<UserInfoModelProvider>();
    final status = provider.getProgressStatus(previous.weight, current.weight);
    final increase = provider.calculateIncrease(previous.weight, current.weight);

    return Container(
      padding: const EdgeInsets.all(20),
      width: TDeviceUtils.getScreenWidth(context)*0.84,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            status.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (status != 'static') Text(
            '${increase.toStringAsFixed(1)}% ${status}',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          // Implement your chart data here
          // You can use fl_chart package for this
        ),
      ),
    );
  }

  Widget _buildComparisonBars(UserInfoModel previous, UserInfoModel current) {
    return Column(
      children: [
        _buildComparisonBar(
          'Lose Weight',
          previous.weight,
          current.weight,
        ),
        const SizedBox(height: 15),
        _buildComparisonBar(
          'Height Increase',
          previous.height,
          current.height,
        ),
        const SizedBox(height: 15),
        _buildComparisonBar(
          'Muscle Mass Increase',
          previous.muscleMass,
          current.muscleMass,
        ),
        const SizedBox(height: 15),
        _buildComparisonBar(
          'Abs',
          previous.abs,
          current.abs,
        ),
      ],
    );
  }

  Widget _buildComparisonBar(String label, double previous, double current) {
    // Safety check for zero values
    if (previous == 0 && current == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 20,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%'),
              Text('0%'),
            ],
          ),
        ],
      );
    }

    // Calculate percentages safely
    int previousPercentage;
    int currentPercentage;

    if (previous == 0) {
      previousPercentage = 0;
      currentPercentage = 100;
    } else if (current == 0) {
      previousPercentage = 100;
      currentPercentage = 0;
    } else {
      final total = previous + current;
      previousPercentage = ((previous / total) * 100).round().clamp(0, 100);
      currentPercentage = ((current / total) * 100).round().clamp(0, 100);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              if (previousPercentage > 0)
                Expanded(
                  flex: previousPercentage,
                  child: Container(
                    height: 20,
                    color: Colors.pink[100],
                  ),
                ),
              if (currentPercentage > 0)
                Expanded(
                  flex: currentPercentage,
                  child: Container(
                    height: 20,
                    color: Colors.blue[200],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$previousPercentage%'),
            Text('$currentPercentage%'),
          ],
        ),
      ],
    );
  }
  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return BMIUpdateDialog();
          },
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[400],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Update',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}