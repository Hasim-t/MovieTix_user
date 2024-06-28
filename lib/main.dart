import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/business_logic/blocs/google/bloc/google_auth_bloc.dart';

import 'package:movie/data/repositories/firebase_options.dart';

import 'package:movie/presentation/screen/splash.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<AuthBlocBloc>(create: (context)=>AuthBlocBloc()..add(CheckLoginStatusEvent())),
      BlocProvider<GoogleAuthBloc>(create: (context)=> GoogleAuthBloc())
    ], child: MyApp())
     );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Splash(),
    );
  }
}

