import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/widgets/custom_subsection_button.dart';
import 'package:heart_disease_prediction/widgets/sign_out_button.dart';

class Subsection extends StatelessWidget {
  final Uri uri;
  final double? width;
  const Subsection({super.key, this.width, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFF262730),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0XFF0E1117),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.monitor_heart_outlined,
                        color: Color(0XFFfe5e3d)),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Heart Disease Prediction",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.white24),
                const SizedBox(height: 10),
                SubsectionButton(
                  title: "Predict",
                  isSelected: uri.path.contains('predict'),
                  routeName: "predict",
                ),
                const SizedBox(height: 15),
                SubsectionButton(
                  title: "Past Record",
                  isSelected: uri.path.contains('pastRecords'),
                  routeName: "pastRecords",
                ),
                const SizedBox(height: 15),
                SubsectionButton(
                  title: "Consult",
                  isSelected: uri.path.contains('consult'),
                  routeName: "consult",
                ),
              ],
            ),
          ),
          const Spacer(),
          const SignOutButton()
        ],
      ),
    );
  }
}
