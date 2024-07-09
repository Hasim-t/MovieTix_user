// profile_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

void showProfileBottomSheet(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.white.withOpacity(0.1), 
    builder: (BuildContext context) {
      return Container(
        height: screenHeight * 0.5,
        width: screenWidth,
        decoration: BoxDecoration(
          color: MyColor().darkblue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 15),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: MyColor().primarycolor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            // Add more content for your bottom sheet here
          ],
        ),
      );
    },
  );
}