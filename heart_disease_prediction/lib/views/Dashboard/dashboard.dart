import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/subsection.dart';

class DashBoard extends StatefulWidget {
  final Widget child;
  const DashBoard({super.key, required this.child});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    var uri = GoRouter.of(context).routeInformationProvider.value.uri;
    return Scaffold(
      backgroundColor: const Color(0XFF0E1117),
      body: Center(
        child: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 1024)
              Expanded(flex: 1, child: Subsection(uri: uri)),
            Expanded(flex: 4, child: widget.child),
          ],
        ),
      ),
    );
  }
}
