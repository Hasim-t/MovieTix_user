import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: MyColor().darkblue,
    appBar:  AppBar(
      title:  Text(" upcoming movie"),
    ),
    );
  }
}