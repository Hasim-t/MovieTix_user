import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future forgotpassword() async {
      try {
       await  FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailcontroller.text.trim());
              PanaraInfoDialog.show(
          context,
          title: "Password Reset",
          message: "A password reset request has been sent to your email.",
          buttonText: "Okay",
          onTapDismiss: () {
            Navigator.of(context).pop();
          },
          panaraDialogType: PanaraDialogType.success,
        );
      } on FirebaseAuthException catch (e) {
                PanaraInfoDialog.show(
          context,
          title: "Error",
          message: e.message.toString(),
          buttonText: "Okay",
          onTapDismiss: () {
            Navigator.of(context).pop();
          },
          panaraDialogType: PanaraDialogType.error,
        );
      }
    }

    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: MyColor().primarycolor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Your Email and we will send you a password reset link ",
              style: TextStyle(
                 fontSize: 15,
                color: MyColor().white),
              textAlign: TextAlign.center,
            ),
           const  SizedBox(height:  20,),
            CustomTextFormField(
                controller: emailcontroller, hintText: "Enter eamil"),
               const  SizedBox(
                  height: 10,
                ),
            ElevatedButton(
                onPressed: forgotpassword, child: const Text("Reset password"))
          ],
        ),
      ),
    );
  }
}
