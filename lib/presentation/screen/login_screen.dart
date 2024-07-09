import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';

import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/bottomnavigation.dart';
import 'package:movie/presentation/screen/forgot_password.dart';
import 'package:movie/presentation/screen/profil_screen.dart';
import 'package:movie/presentation/screen/register.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authbloc = BlocProvider.of<AuthBlocBloc>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Bottomnavigation()),
            (route) => false,
          );
        } else if (state is AutheticatedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.msg)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColor().darkblue,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: Form(
            key: _formKey,
            child: CustomScrollView(
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
                            errorText: "Email is required",
                            prefixIcon: const Icon(Icons.email),
                            controller: _emailcontroller,
                            hintText: 'email'),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomTextFormField(
                            errorText: 'Password is required',
                            prefixIcon: const Icon(Icons.person),
                            obscureText: true,
                            controller: _passwordcontroller,
                            hintText: "Password"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ForgotPassword();
                                }));
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(color: MyColor().primarycolor),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.08,
                        ),
                        InkWell(
                          onTap: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    authbloc.add(LoingEvent(
                                      email: _emailcontroller.text.trim(),
                                      password: _passwordcontroller.text.trim(),
                                    ));
                                  }
                                },
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: MyColor().primarycolor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: state is AuthLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                            ),
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
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<AuthBlocBloc>()
                                .add(GoogleSignInEvent());
                          },
                          child: Container(
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                    color: MyColor().gray, width: 0.5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'asset/Google_png.png',
                                  height: 25,
                                  width: 25,
                                ),
                                const Text(
                                  "  Login With Goolge",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return RegisterPage();
                                  }));
                                },
                                child: Text(
                                  'Register',
                                  style:
                                      TextStyle(color: MyColor().primarycolor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }
}
