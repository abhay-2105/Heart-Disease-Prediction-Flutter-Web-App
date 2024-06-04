import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubsectionButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final String routeName;
  const SubsectionButton(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.routeName});

  @override
  State<SubsectionButton> createState() => _SubsectionButtonState();
}

class _SubsectionButtonState extends State<SubsectionButton> {
  Color? color;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          color = Colors.blueGrey.withOpacity(0.2);
        });
      },
      onExit: (event) {
        setState(() {
          color = null;
        });
      },
      child: InkWell(
        onTap: () {
          context.goNamed(widget.routeName);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isSelected ? const Color(0XFFfe5e3d) : color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
