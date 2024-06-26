import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';


import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/profil_screen.dart';
import 'package:movie/presentation/screen/register.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authbloc = BlocProvider.of<AuthBlocBloc>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(builder: (context, state) {
      if (state is Authenticated) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return ProfilScreen();
          }), (route) => false);
        });
      }

      return Scaffold(
          backgroundColor: MyColor().darkblue,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Center(
                        child: Image.asset(
                          'asset/Movitix_titile_blue.png',
                          width: screenWidth * 0.7,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Log in to your account using email ',
                        style: TextStyle(
                            fontFamily: 'Cabin',
                            color: MyColor().primarycolor,
                            fontSize: 19),
                      ),
                      Text(
                        'or Google Account ',
                        style: TextStyle(
                            fontFamily: 'Cabin',
                            color: MyColor().primarycolor,
                            fontSize: 19),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextFormField(
                        prefixIcon: const Icon(Icons.email),
                          controller: _emailcontroller, hintText: 'email'),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextFormField(
                        prefixIcon: const Icon(Icons.person),
                          obscureText: true,
                          controller: _passwordcontroller,
                          hintText: "Password"),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          authbloc.add(LoingEvent(
                              email: _emailcontroller.text.trim(),
                              password: _passwordcontroller.text.trim()));
                        },
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: MyColor().primarycolor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                              child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                     Row(
      children: [
        Expanded(
          child: Divider(
            color: MyColor().gray,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        Text(
          "Or continue with Google account",
          style: TextStyle(color: MyColor().gray),
        ),
        Expanded(
          child: Divider(
            color: MyColor().gray,
            thickness: 1,
            indent: 10,
          ),
        ),
      ],
    ),
   const SizedBox(
      height:  20,
    ),
    InkWell(
     onTap: () {
     context.read<AuthBlocBloc>().add(GoogleSignInEvent());
  },
      child: Container(
       
        height: screenHeight * 0.06,
         width: screenWidth * 0.9,
         decoration:  BoxDecoration(
           borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color:  MyColor().gray,
            width: 0.5
          )
         ),
         child:  Row(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Image.asset('asset/Google_png.png', height:  25,width: 25,),
           const  Text("  Login With Goolge", style: TextStyle( color:  Colors.white, fontSize:  18),)
          ],
         ),
      
      ),
    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Didn’t have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return RegisterPage();
                                }));
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: MyColor().primarycolor),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}
