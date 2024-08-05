import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/names.dart';
import 'package:movie/presentation/widgets/show_bottomsheet.dart';
class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar:AppBar(
          elevation: 0,
          foregroundColor: MyColor().primarycolor,
          backgroundColor: MyColor().darkblue,
          title: Text('Profile',
              style: TextStyle(
                  color: MyColor().primarycolor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                 Center(
                  child: CircleAvatar(
                    radius: screenHeight * 0.11,
                    backgroundImage: userData['profileImageUrl'] != null
                        ? NetworkImage(userData['profileImageUrl'])
                        : const AssetImage('asset/avatar png.png') as ImageProvider,
                    child: userData['profileImageUrl'] == null
                        ? null
                        : Container(),
                  ),
                ),
                Text(
                  
                  userData['name'] ?? 'User',
                  style: TextStyle(
                    
                    color: MyColor().primarycolor,
                    fontFamily: 'Cabin',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Divider(),
                SizedBox(height: screenHeight * 0.02),
                CoustomNameRow(label: "Email", value: userData['email'] ?? 'No email'),
               const SizedBox(height: 10),
                CoustomNameRow(label: 'Phone', value: userData['phone'] ?? 'No phone'),
               const  SizedBox(height: 10),
                CoustomNameRow(label: 'Gender', value: userData['gender'] ?? 'Not specified'),
               const SizedBox(height: 10),
                CoustomNameRow(label: 'Date of Birth', value: userData['dateOfBirth'] ?? 'Not specified'),
               const  SizedBox(height: 10),
                CoustomNameRow(label: 'Marital Status', value: userData['maritalStatus'] ?? 'Not specified'),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    showProfileBottomSheet(context, userData);
                  },
                  child: Text("Edit"),
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          );
        },
      ),
    );
  }
}