import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:movie/business_logic/blocs/BottomNav/bloc/bottom_nav_bloc.dart';
import 'package:movie/business_logic/blocs/auth/bloc/auth_bloc_bloc.dart';
import 'package:movie/business_logic/blocs/movie/bloc/movie_bloc.dart';

import 'package:movie/data/repositories/firebase_options.dart';
import 'package:movie/data/repositories/gemini.dart';

import 'package:movie/presentation/screen/mainscreen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: Gemini_API_Key);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiBlocProvider(providers: [
    BlocProvider<BottomNavBloc>(create: (context) => BottomNavBloc()),
    BlocProvider<AuthBlocBloc>(
        create: (context) => AuthBlocBloc()..add(CheckLoginStatusEvent())),
    BlocProvider<MovieBloc>(
      create: (context) =>
          MovieBloc(FirebaseFirestore.instance)..add(FetchMovies()),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Splash(),
    );
  }
}
