import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/ticket_widget.dart';
import 'package:ticket_widget/ticket_widget.dart';

class TicketScreen extends StatelessWidget {
  final dynamic movieName;
  final String theaterName;
  final int numberOfSeats;
  final List<String> seatNumbers;
  final DateTime date;
  final String time;
  final String screenName; 

  const TicketScreen({
    super.key,
    required this.movieName,
    required this.theaterName,
    required this.numberOfSeats,
    required this.seatNumbers,
    required this.date,
    required this.time,
    required this.screenName, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: const Text('Ticket'),
      ),
      body: Center(
        child: TicketWidget(
          isCornerRounded: true,
          padding: const EdgeInsets.all(20),
          width: 350,
          height: 560,
          child: TicketData(
            movieName: movieName,
            theaterName: theaterName,
            numberOfSeats: numberOfSeats,
            seatNumbers: seatNumbers,
            date: date,
            time: time,
            screenName:screenName 
          ),
        ),
      ),
    );
  }
}
