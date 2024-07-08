import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:  MyColor().darkblue,
    appBar:  AppBar(
      title:  Text("Home"),
    ),
    );
  }
}