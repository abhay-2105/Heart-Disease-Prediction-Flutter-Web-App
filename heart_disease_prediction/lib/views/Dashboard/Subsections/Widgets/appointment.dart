import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_disease_prediction/Services/app_service.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/Widgets/appointment_fix.dart';
import 'package:heart_disease_prediction/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AppointmentDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  const AppointmentDialog({super.key, required this.data});

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  bool validation = false;
  late DateTime? appointmentDate;
  TextEditingController recordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateControlller = TextEditingController();

  validate() {
    if (recordController.text.isNotEmpty && dateControlller.text.isNotEmpty) {
      validation = true;
    } else {
      validation = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const border =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white38));
    return SizedBox(
      width: screenWidth * 0.2,
      child: Column(
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
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(widget.data['imageUrl']),
          ),
          const SizedBox(height: 20),
          Text(
            "Book Apointment\nwith ${widget.data['name']}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: recordController,
              cursorColor: Colors.red,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (value) {
                validate();
              },
              decoration: const InputDecoration(
                  labelText: "Record Id",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border),
            ),
          ),
          // const SizedBox(height: 15),
          // SizedBox(
          //   height: 50,
          //   child: TextFormField(
          //     controller: phoneController,
          //     cursorColor: Colors.red,
          //     style: const TextStyle(color: Colors.white, fontSize: 16),
          //     inputFormatters: [PhoneInputFormatter()],
          //     onChanged: (value) {
          //       validate();
          //     },
          //     decoration: const InputDecoration(
          //         labelText: "Phone no",
          //         labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          //         border: border,
          //         focusedBorder: border,
          //         enabledBorder: border),
          //   ),
          // ),
          const SizedBox(height: 15),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: dateControlller,
              readOnly: true,
              onTap: () async {
                appointmentDate = await showDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: const Color(0XFF262730),
                            datePickerTheme: DatePickerThemeData(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                surfaceTintColor: Colors.transparent,
                                backgroundColor: const Color(0XFF262730),
                                yearForegroundColor:
                                    const MaterialStatePropertyAll(
                                        Colors.white)),
                            brightness: Brightness.dark,
                            textTheme: const TextTheme(
                                bodyMedium: TextStyle(color: Colors.white),
                                titleMedium: TextStyle(color: Colors.white)),
                            inputDecorationTheme: InputDecorationTheme(
                                focusColor: Colors.white38,
                                labelStyle:
                                    const TextStyle(color: Colors.white38),
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                )),
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0XFFfe5e3d),
                              onPrimary: Colors.black,
                              surface: Color(0XFF262730),
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          child: child!);
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)));
                if (appointmentDate != null) {
                  dateControlller.text =
                      DateFormat("dd MMM yyyy").format(appointmentDate!);
                  validate();
                }
              },
              cursorColor: Colors.red,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                  labelText: "Choose Date",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            title: "Confirm",
            onPressed: validation
                ? () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("Dataset")
                          .doc(recordController.text)
                          .update({
                        "doctorId": widget.data['id'],
                        "appointmentDate": appointmentDate
                      });
                      if (!mounted) return;
                      context.pop();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              backgroundColor: const Color(0XFF262730),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              content: AppointmentScheduledDialog(
                                  doctorName: widget.data['name'],
                                  date: dateControlller.text)));
                    } catch (error) {
                      AppServices.openSnackbar(context,
                          "Record does not exist. Please check your record ID");
                    }
                  }
                : null,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Only allow digits and limit input to 10 characters
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedText.length > 10) {
      cleanedText = cleanedText.substring(0, 10);
    }

    // Format the phone number as ###-###-####
    final StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < cleanedText.length; i++) {
      formattedText.write(cleanedText[i]);
      if (i == 2 || i == 5) {
        formattedText.write('-');
      }
    }

    return newValue.copyWith(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
