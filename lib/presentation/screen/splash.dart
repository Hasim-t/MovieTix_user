import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/bottomnavigation.dart';
import 'package:movie/presentation/screen/login_screen.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Bottomnavigation();
          }));
        } else if (state is UnAutheticated) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
        }
      },
      child: Scaffold(
        backgroundColor: MyColor().primarycolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('asset/movietix_logo.png'))
            ],
          ),
        ),
      ),
    );
  }
}
