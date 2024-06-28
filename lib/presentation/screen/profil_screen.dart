import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/presentation/screen/login_screen.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  for (UserInfo userInfo in user.providerData) {
                    if (userInfo.providerId == 'google.com') {
                      context.read<AuthBlocBloc>().add(GoogleLogoutEvent());
                      return;
                    }
                  }
                  // If not Google, assume email
                  context.read<AuthBlocBloc>().add(EmailLogoutEvent());
                }
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        // ... rest of your widget tree
      ),
    );
  }
}