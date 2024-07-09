// profile_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

void showProfileBottomSheet(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController  phonecontroller = TextEditingController();
  TextEditingController  Gentercontroller  = TextEditingController();
  TextEditingController   Dobcontroller  = TextEditingController();
  TextEditingController   maragecontroller  = TextEditingController();


  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.white.withOpacity(0.1),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          
          width: screenWidth,
          decoration: BoxDecoration(
            color: MyColor().darkblue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
             padding:  const EdgeInsets.symmetric(horizontal:30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 15),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColor().primarycolor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                SizedBox(
                  height:  10,
                ),
                Text("Edit Profile",style: TextStyle(color: MyColor().primarycolor),),
                const SizedBox(height: 20,),
                CustomTextFormField(controller: namecontroller, hintText: "Name"),
               const  SizedBox(height: 20,),
                CustomTextFormField(controller: phonecontroller, hintText: "Phone"),
           const        SizedBox(height: 20,),
                CustomTextFormField(controller: Gentercontroller, hintText: "Genter"),
              const  SizedBox(height: 20,),
               CustomTextFormField(controller: Dobcontroller, hintText: "Date of Birth"),
               const  SizedBox(height: 20,),
                CustomTextFormField(controller: maragecontroller, hintText: "Marital Status"),
              const   SizedBox(height: 20,),
              
              ],
            ),
          ),
        ),
      );
    },
  );
}
