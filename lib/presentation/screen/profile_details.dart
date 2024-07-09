import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/names.dart';

class MyPofile extends StatelessWidget {
  const MyPofile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        foregroundColor: MyColor().primarycolor,
        elevation: 0,
        backgroundColor: MyColor().darkblue,
        title: Text('Profile',
            style: TextStyle(
                color: MyColor().primarycolor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cabin')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
             SizedBox(
              height:  screenHight * 0.02,
             ),
             Center(child: Image.asset('asset/avatar png.png',height:screenHight * 0.22,)),
        Text(
                  'Muhammaed Hashim.t',
                  style: TextStyle(
                    color: MyColor().primarycolor,
                    fontFamily: 'Cabin',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHight * 0.02,
                ),
                const Divider(),
                SizedBox(
                  height:  screenHight *0.02,
                ),
            const CoustomNameRow( label: "eamil", value: 'hashimmuhammad@gamil.com'),
            const SizedBox(height:  10,),
             const CoustomNameRow(label: 'Phone', value: '7736463266'),
            const SizedBox(height:  10,),
            const  CoustomNameRow(label: 'Gender', value: 'male'),
            const SizedBox(height:  10,),
            const  CoustomNameRow(label: 'Date of Birth', value: '24/05/2002'),
             const SizedBox(height:  10,),
            const  CoustomNameRow(label: 'Marital Status', value: 'Unmarried'),

            Spacer(),
            ElevatedButton(onPressed: (){}, child: Text("edit"))
          , SizedBox(
            height:  screenHight * 0.1,
          )
             
          ],
        ),
      ),
    );
  }
}
