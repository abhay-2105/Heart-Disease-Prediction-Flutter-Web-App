import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/Services/app_service.dart';
import 'package:heart_disease_prediction/widgets/custom_textfeild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/heart_bg.jpg"))),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.2,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0XFFfe5e3d).withOpacity(0.1),
                              offset: const Offset(0, -4),
                              blurRadius: 20)
                        ]),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Heart Disease Prediction",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFFfe5e3d),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "User Login",
                            style: TextStyle(
                              fontSize: 24,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFFfe5e3d),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: 300,
                              child: CustomTextFeild(
                                hintText: "Username",
                                onChanged: (val) {
                                  email = val;
                                },
                              )),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: 300,
                              child: CustomTextFeild(
                                hintText: "Password",
                                onChanged: (val) {
                                  password = val;
                                },
                              )),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    AppServices.signUpUser(context, mounted,
                                        email: email, password: password);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    AppServices.loginUser(context, mounted,
                                        email: email, password: password);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
