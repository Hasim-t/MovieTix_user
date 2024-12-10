import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie/business_logic/blocs/ticket/bloc/ticket_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/view_ticket.dart';


class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketBloc(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      )..add(LoadTickets()),
      child: Scaffold(
        backgroundColor: MyColor().darkblue,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColor().primarycolor,
          title: const Text("Your Tickets"),
          centerTitle: true,
          elevation: 4,
        ),
        body: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is TicketLoaded) {
              final tickets = state.tickets;
              if (tickets.isEmpty) {
                return const Center(
                  child: Text(
                    "No tickets found",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: tickets.length,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                itemBuilder: (context, index) {
                  final ticket = tickets[index].data() as Map<String, dynamic>;
                  final movieName = ticket['movieName'] ?? 'Unknown';
                  final time = ticket['time'] ?? 'Unknown time';
                  final date = (ticket['date'] as Timestamp).toDate();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketViewScreen(
                            movieName: movieName,
                            theaterName: ticket['theaterName'] ?? 'Unknown',
                            numberOfSeats: ticket['numberOfSeats'] ?? 0,
                            seatNumbers: List<String>.from(ticket['seatNumbers'] ?? []),
                            date: date,
                            time: time,
                          ),
                        ),
                      );
                    },
                    child: TicketCard(
                      movieName: movieName,
                      date: date,
                      time: time,
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String movieName;
  final DateTime date;
  final String time;

  const TicketCard({
    super.key,
    required this.movieName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColor().primarycolor.withOpacity(0.8),
            MyColor().primarycolor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        leading: Icon(Icons.movie, color: MyColor().white, size: 28),
        title: Text(
          movieName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Date: ${date.day}/${date.month}/${date.year}\nTime: $time',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}