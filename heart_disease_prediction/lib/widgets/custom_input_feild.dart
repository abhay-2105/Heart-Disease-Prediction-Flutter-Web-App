import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputFeild extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const CustomInputFeild(
      {super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width * 0.57) / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextField(
              controller: controller,
              inputFormatters: [DecimalTextInputFormatter()],
              cursorColor: Colors.red,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0XFF262730),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
