import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/home/widget/bmi_scorrer.dart';
import '../../providers/user_info_provider.dart';
import '../../utils/constants/colors.dart';

class BmiPieBuilder extends StatelessWidget {
  const BmiPieBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: context.read<UserInfoModelProvider>().getUserBMI(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == 0.0) {
          return const Text("Internet is down");
        }

        final bmi = snapshot.data!;
        final provider = context.read<UserInfoModelProvider>();
        final category = provider.getBMICategory(bmi);
        final categoryColor = provider.getBMICategoryColor(bmi);

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return AnimatedBmiPie(bmi: bmi);
        }
      },
    );
  }
}
class AnimatedBmiPie extends StatelessWidget {
  const AnimatedBmiPie({super.key, required this.bmi});
  final double bmi;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: TColors.white,
      ),
      child: AnimatedPieChart(
        percentage: bmi,
        color: Colors.purple.shade300,
      ),
    );
  }
}
