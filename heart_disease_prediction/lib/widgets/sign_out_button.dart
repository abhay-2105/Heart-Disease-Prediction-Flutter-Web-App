import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_disease_prediction/Services/app_service.dart';
import 'package:heart_disease_prediction/widgets/custom_button.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({super.key});

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
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
          if (context.canPop()) {
            context.pop();
          }
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: const Color(0XFF262730),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                  visualDensity: const VisualDensity(
                                      vertical: -4, horizontal: -4),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0XFF0E1117),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.logout_outlined,
                                color: Colors.white, size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text("Are you sure you want to logout?",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 30),
                          CustomButton(
                              onPressed: () {
                                AppServices.signOut(context);
                              },
                              title: "Logout",
                              bgColor: Colors.red),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text("Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
