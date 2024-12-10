import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title:  const Text('Terms and Conditions'),
        backgroundColor: MyColor().primarycolor, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Terms and Conditions for MovieTix



1. Acceptance of Terms

By using the MovieTix application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the app.

2. User Accounts

To use certain features of the app, you may be required to create an account. You agree to provide accurate and up-to-date information during the registration process. You are responsible for maintaining the confidentiality of your account and password.

3. Movie Ticket Booking

The app allows you to book movie tickets. All bookings are subject to availability. We reserve the right to cancel any booking if necessary, and you will be notified of any such cancellations.

4. Payments

All payments made through the app are processed via Razorpay. By making a payment, you agree to Razorpay's terms and conditions. We are not responsible for any issues that may arise during the payment process.

5. Cancellations and Refunds

Cancellations and refunds are subject to the policies of the respective theaters. We do not control or guarantee any refunds or cancellations, and you must contact the theater directly for any such requests.

6. User Conduct

You agree to use the app in a manner that is lawful and respectful to other users. You are prohibited from using the app to engage in any illegal activities or to distribute harmful content.

7. Intellectual Property

All content, trademarks, and intellectual property associated with the MovieTix app are the property of [Your Company Name] or its licensors. You may not use, reproduce, or distribute any content from the app without prior written permission.

8. Limitation of Liability

We are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the app. This includes, but is not limited to, loss of data, loss of profits, or any other damages related to the use of the app.

9. Modifications to the App

We reserve the right to modify, suspend, or discontinue the app at any time without prior notice. We are not liable for any changes that may affect your use of the app.

10. Governing Law

These Terms and Conditions are governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising from these terms shall be resolved in the courts of [Your Jurisdiction].

11. Changes to Terms and Conditions

We may update these Terms and Conditions from time to time. Any changes will be posted on this page with the updated effective date. Your continued use of the app after any changes indicates your acceptance of the new terms.

12. Contact Us

If you have any questions or concerns about these Terms and Conditions, please contact us at [Insert Contact Information].

Thank you for using MovieTix!
            ''',
            style: TextStyle(color: MyColor().white), // Adjust text color according to your theme
          ),
        ),
      ),
    );
  }
}
