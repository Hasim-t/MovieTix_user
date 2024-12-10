import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/data/repositories/image_picker.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/login/login_screen.dart';
import 'package:movie/presentation/screen/login/profile_details.dart';
import 'package:movie/presentation/screen/settings/privacy_policy.dart';
import 'package:movie/presentation/screen/settings/terms_and_conditions.dart';
import 'package:movie/presentation/widgets/icon_text_row.dart';
import 'package:share_plus/share_plus.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {

    
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final User? currentUser = FirebaseAuth.instance.currentUser;

    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is UnAutheticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: MyColor().darkblue,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: MyColor().darkblue,
          title: Text('Profile',
              style: TextStyle(
                  color: MyColor().primarycolor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: MyColor().primarycolor));
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: MyColor().red)));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                      child: Text('No user data found',
                          style: TextStyle(color: MyColor().primarycolor)));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String name = userData['name'] ?? 'User';
                String email = userData['email'] ?? 'No email';
                String? profileImageUrl = userData['profileImageUrl'];

                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const MyProfile()));
                            },
                            child: CircleAvatar(
                              radius: screenHeight * 0.1,
                              backgroundImage: profileImageUrl != null
                                  ? NetworkImage(profileImageUrl)
                                  : const AssetImage('asset/avatar png.png')
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColor().primarycolor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon:
                                    Icon(Icons.edit, color: MyColor().darkblue),
                                onPressed: () {
                                  showImageSourceDialog(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      name,
                      style: TextStyle(
                        color: MyColor().primarycolor,
                        fontFamily: 'Cabin',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      email,
                      style: TextStyle(
                        color: MyColor().primarycolor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Divider(color: MyColor().primarycolor.withOpacity(0.2)),
                    SizedBox(height: screenHeight * 0.02),
                    CoustomRowIcontext(
                      icon: Icons.privacy_tip,
                      text: 'Privacy',
                      ontap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const PrivacyPolicy();
                        }));
                      },
                    ),
                    CoustomRowIcontext(
                      icon: Icons.description,
                      text: 'Terms and conditions',
                      ontap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const TermsAndConditions();
                        }));
                      },
                    ),
                    // CoustomRowIcontext(
                    //   icon: Icons.dark_mode,
                    //   text: 'Dark Mode',
                    //   ontap: () {},
                    // ),
                    CoustomRowIcontext(
  icon: Icons.share,
  text: 'Share',
  ontap: () {
    const String appUrl = 'https://www.amazon.com/dp/B0DGD9VNSL/ref=apps_sf_sta';
    Share.share('Check out this amazing app: $appUrl', subject: 'Movietix App');
  },
),
                    CoustomRowIcontext(
                      icon: Icons.logout,
                      text: 'Logout',
                      color: MyColor().red,
                      ontap: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          for (UserInfo userInfo in user.providerData) {
                            if (userInfo.providerId == 'google.com') {
                              context
                                  .read<AuthBlocBloc>()
                                  .add(GoogleLogoutEvent());
                              return;
                            }
                          }
                          context.read<AuthBlocBloc>().add(EmailLogoutEvent());
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  
  
}
