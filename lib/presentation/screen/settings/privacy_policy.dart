import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: MyColor().primarycolor,
      ),
      body: const Padding(
        padding:  EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:   Text(
            '''
Privacy Policy for MovieTix

Effective Date: [Insert Date]

1. Introduction

Welcome to MovieTix! This privacy policy outlines how we collect, use, and protect your personal information when you use our movie ticket booking application.

2. Information We Collect

We collect the following personal information when you use our app:
- Email address
- Name
- Phone number (optional)

3. How We Use Your Information

We use your personal information for the following purposes:
- To book movie tickets and manage your bookings.
- To process payments via Razorpay.
- To communicate with you about your bookings and app-related updates.

4. Payment Information

We use Razorpay as our payment gateway. Razorpay may collect and process your payment information. We do not store your payment details on our servers. Please refer to Razorpay's privacy policy for more information on how they handle your payment data.

5. Data Sharing

We do not share your personal information with any third parties except for the following:
- With Razorpay for processing payments.
- As required by law, such as to comply with a subpoena or similar legal process.

6. Data Security

We take the security of your personal information seriously. We use Firebase for backend services, and your data is stored securely with Firebase's cloud infrastructure. We implement industry-standard security measures to protect your data from unauthorized access.

7. Your Rights

You have the right to:
- Access and update your personal information.
- Request the deletion of your personal data.
- Opt out of receiving promotional communications.

8. Changes to This Privacy Policy

We may update this privacy policy from time to time. Any changes will be posted on this page with the updated effective date. We encourage you to review this policy periodically to stay informed about how we are protecting your information.

9. Contact Us

If you have any questions or concerns about this privacy policy or our data practices, please contact us at [Insert Contact Information].

By using MovieTix, you agree to this privacy policy.

Thank you for using MovieTix!
            ''',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
