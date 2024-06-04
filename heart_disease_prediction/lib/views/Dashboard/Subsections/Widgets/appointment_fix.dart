import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppointmentScheduledDialog extends StatelessWidget {
  final String doctorName;
  final String date;
  const AppointmentScheduledDialog(
      {super.key, required this.doctorName, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ))
          ],
        ),
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 35,
          ),
        ),
        const SizedBox(height: 20),
        Text("Appointment with $doctorName\non $date is booked\nsuccessfully.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16))
      ],
    );
  }
}
