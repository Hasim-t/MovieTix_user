import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/data/models/user_model.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/mainscreen/profil_screen.dart';
import 'package:movie/presentation/widgets/textfromwidget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailnamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final _forKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    final authbloc = BlocProvider.of<AuthBlocBloc>(context);
   return BlocConsumer<AuthBlocBloc, AuthBlocState>(
  listener: (context, state) {
    if (state is Authenticated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfilScreen()),
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
        appBar: AppBar(
          backgroundColor: MyColor().darkblue,
          iconTheme: IconThemeData(color: MyColor().primarycolor),
        ),
        body: Form(
          key:  _forKey,
          child: Padding(
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
                        errorText: "Name is required",
                          prefixIcon: const Icon(Icons.person),
                          controller: _namecontroller,
                          hintText: "Full Name"),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                        errorText: "Email is required",
                          prefixIcon: const Icon(Icons.email),
                          controller: _emailnamecontroller,
                          hintText: " Email"),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                          errorText: "Username is required",
                          prefixIcon:const Icon(Icons.alternate_email_rounded),
                          controller: _usernamecontroller,
                          hintText: "Username"),
                     const  SizedBox(
                        height: 30,
                      ),
                      CustomTextFormField(
                        errorText: "Password is required",
                           prefixIcon: const Icon(Icons.lock),
                          controller: _passwordcontroller,
                          hintText: "Password"),
                      const SizedBox(
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
    child: state is AuthLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : InkWell(
          onTap: () {
            if(_forKey.currentState!.validate()){
              UserModel user = UserModel(
                name: _namecontroller.text,
                email: _emailnamecontroller.text,
                password: _passwordcontroller.text,
                userid: _usernamecontroller.text);
              authbloc.add(SingupEvnet(user: user));
            }
          },
          child: const Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
  ),
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
                              child: Text(
                                "Login Here",
                                style: TextStyle(color: MyColor().primarycolor),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: MyColor().darkblue,
      );
    });
  }
}
