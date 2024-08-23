import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/BottomNav/bloc/bottom_nav_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/mainscreen/booking_screen.dart';
import 'package:movie/presentation/screen/mainscreen/home_screen.dart';
import 'package:movie/presentation/screen/mainscreen/profil_screen.dart';
import 'package:movie/presentation/screen/mainscreen/theater_screen.dart';
import 'package:movie/presentation/screen/mainscreen/upcoming_screen.dart';
class Bottomnavigation extends StatelessWidget {
  Bottomnavigation({super.key});

  final List<Widget> pages = [
    const Homescreen(),
   const TheaterScreen(),
   const UpcomingScreen(),
    const  BookingScreen(),
     const ProfilScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColor().darkblue,
          body: pages[state.selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              child: FlashyTabBar(
                showElevation: true,
                selectedIndex: state.selectedIndex,
       
                onItemSelected: (index) {
                  context.read<BottomNavBloc>().add(ChangeBottomNavIndex(index));
                },
                items: [
                  FlashyTabBarItem(icon: const Icon(Icons.home), title:  Text("Home",style: TextStyle(
                    color: MyColor().primarycolor
                  ),)),
                  FlashyTabBarItem(icon: const Icon(Icons.tv), title:  Text("Theater",style: TextStyle(
                    color: MyColor().primarycolor
                  ))),
                  FlashyTabBarItem(icon: const Icon(Icons.movie), title: Text("upcoming",style: TextStyle(
                    color: MyColor().primarycolor
                  ))),
                  FlashyTabBarItem(icon: const Icon(Icons.local_movies_sharp), title: Text("bookings",style: TextStyle(
                    color: MyColor().primarycolor
                  ))),
                  FlashyTabBarItem(icon: const Icon(Icons.person), title: Text("Profile",style: TextStyle(
                    color: MyColor().primarycolor
                  ))),
                ]
              ),
            ),
          )
        );
      },
    );
  }
}