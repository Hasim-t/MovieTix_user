import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/data/models/user_model.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/profil_screen.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailnamecontroller = TextEditingController();
  TextEditingController _Passwordcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    final authbloc = BlocProvider.of<AuthBlocBloc>(context);
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
        appBar: AppBar(
          backgroundColor: MyColor().darkblue,
          automaticallyImplyLeading: false,
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
                      height: screenheight * 0.029,
                    ),
                    Text(
                      'Create an Account',
                      style: TextStyle(
                          color: MyColor().primarycolor,
                          fontFamily: 'Cabin',
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextFormField(
                        controller: _namecontroller,
                        hintText: "Enter full name"),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        controller: _emailnamecontroller,
                        hintText: "Enter  email"),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        controller: _usernamecontroller,
                        hintText: "Enter username"),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        controller: _Passwordcontroller,
                        hintText: "ented password"),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: screenwidth * 0.4,
                      height: screenheight * 0.05,
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
                              password: _Passwordcontroller.text,
                              userid: _usernamecontroller.text);
                          authbloc.add(SingupEvnet(user: user));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '  alredy have an accound ',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: MyColor().darkblue,
      );
    });
  }
}
