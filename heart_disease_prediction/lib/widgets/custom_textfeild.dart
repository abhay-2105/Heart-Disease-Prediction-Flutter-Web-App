import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool showDivider;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final double? height;
  final double? width;
  final double? fontSize;
  final int? maxLines;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextFeild(
      {super.key,
      this.controller,
      this.hintText,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.height,
      this.width,
      this.onChanged,
      this.inputFormatters,
      this.fontSize = 16,
      this.maxLines = 1,
      this.textAlign = TextAlign.start,
      this.showDivider = true,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          Row(
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: prefixIcon!,
                ),
              Expanded(
                child: SizedBox(
                  height: height,
                  child: TextFormField(
                    cursorHeight: 24,
                    cursorWidth: 1.5,
                    cursorColor: Colors.red,
                    controller: controller,
                    readOnly: readOnly,
                    maxLines: maxLines,
                    textInputAction: TextInputAction.done,
                    keyboardType: keyboardType,
                    onTap: onTap,
                    textAlign: textAlign,
                    textAlignVertical: TextAlignVertical.bottom,
                    onChanged: onChanged,
                    inputFormatters: inputFormatters,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      isDense: true,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: suffixIcon!,
                ),
            ],
          ),
          if (showDivider) const Divider(color: Color(0XFFE6EBEF), height: 10),
        ],
      ),
    );
  }
}
