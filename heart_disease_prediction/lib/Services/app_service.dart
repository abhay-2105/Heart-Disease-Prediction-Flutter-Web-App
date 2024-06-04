import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppServices {
  static loginUser(BuildContext context, bool mounted,
      {required String? email, required String? password}) async {
    String errorText = '';
    if (email == null && password == null) {
      errorText = "Please enter email and password.";
    } else if (email == null) {
      errorText = "Please enter email.";
    } else if (password == null) {
      errorText = "Please enter password.";
    }

    if (errorText.isNotEmpty) {
      openSnackbar(context, errorText);
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);
        if (!mounted) return;
        openSnackbar(context, "Login successful.", isError: false);
        context.goNamed('predict');
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        String? errorMessage;
        if (error.code == "configuration-not-found") {
          errorMessage =
              "Account not found. Please sign up to create a account.";
        }
        openSnackbar(context, errorMessage ?? error.message.toString());
      }
    }
  }

  static sendDataToFirebase(List<double> data, int predict) async {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("Dataset").doc();

    await doc.set({
      'docId': doc.id,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      "data": data,
      "target": predict,
      "time": DateTime.now()
    });
  }

  static signUpUser(BuildContext context, bool mounted,
      {required String? email, required String? password}) async {
    String errorText = '';
    if (email == null && password == null) {
      errorText = "Please enter email and password.";
    } else if (email == null) {
      errorText = "Please enter email.";
    } else if (password == null) {
      errorText = "Please enter password.";
    }

    if (errorText.isNotEmpty) {
      openSnackbar(context, errorText);
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        if (!mounted) return;
        openSnackbar(context, "Account created successfully.", isError: false);
        context.goNamed('predict');
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        openSnackbar(context, error.message.toString());
      }
    }
  }

  static signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      context.goNamed("loginPage");
    });
  }

  static openSnackbar(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }
}
