import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  MyColor().darkblue,
      appBar:  AppBar(
         backgroundColor:  MyColor().primarycolor,
        title: const  Text("Booking screen"),
      ),
    );
  }
}