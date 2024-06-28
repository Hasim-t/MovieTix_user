import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/data/models/user_model.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/profil_screen.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
 final  TextEditingController _namecontroller = TextEditingController();
 final TextEditingController _emailnamecontroller = TextEditingController();
 final TextEditingController _passwordcontroller = TextEditingController();
 final TextEditingController _usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    final authbloc = BlocProvider.of<AuthBlocBloc>(context);
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(builder: (context, state) {
      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return ProfilScreen();
          }), (route) => false);
        });
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor().darkblue,
          iconTheme: IconThemeData(color: MyColor().primarycolor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'asset/Movitix_titile_blue.png',
                        width: screenwidth * 0.7,
                      ),
                    ),
                    SizedBox(
                      height: screenheight * 0.1,
                    ),
                    Text(
                      'Create an Account',
                      style: TextStyle(
                          color: MyColor().primarycolor,
                          fontFamily: 'Cabin',
                          fontSize: 24),
                    ),
                   const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                        prefixIcon: Icon(Icons.person),
                        controller: _namecontroller,
                        hintText: "Full Name"),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        prefixIcon: const Icon(Icons.email),
                        controller: _emailnamecontroller,
                        hintText: " Email"),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                        controller: _usernamecontroller,
                        hintText: "Username"),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        prefixIcon: Icon(Icons.lock),
                        controller: _passwordcontroller,
                        hintText: "Password"),
                  const    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: screenwidth * 0.9,
                      height: screenheight * 0.06,
                      decoration: BoxDecoration(
                        color: MyColor().primarycolor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          UserModel user = UserModel(
                              name: _namecontroller.text,
                              email: _emailnamecontroller.text,
                              password: _passwordcontroller.text,
                              userid: _usernamecontroller.text);
                          authbloc.add(SingupEvnet(user: user));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const Text(
                          ' Already have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Login Here", style: TextStyle(
                              color:  MyColor().primarycolor
                            ),))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: MyColor().darkblue,
      );
    });
  }
}
