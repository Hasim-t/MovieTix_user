import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie/business_logic/blocs/TheaterBooking/bloc/theater_booking_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/showing_seat.dart';

class TheaterBookingScreen extends StatelessWidget {
  final String movieId;
  final Map<String, dynamic> movieData;

  const TheaterBookingScreen(
      {super.key, required this.movieId, required this.movieData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TheaterBookingBloc(
        movieId: movieId,
        firestore: FirebaseFirestore.instance,
      )
        ..add(LoadAvailableDates())
        ..add(LoadTheaters()),
      child: TheaterBookingView(movieData: movieData, movieId: movieId),
    );
  }
}

class TheaterBookingView extends StatelessWidget {
  final Map<String, dynamic> movieData;
  final String movieId;

  const TheaterBookingView(
      {super.key, required this.movieData, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyColor().white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            Text(movieData['name'], style: TextStyle(color: MyColor().white)),
      ),
      body: Column(
        children: [
          _buildMovieHeader(),
          _buildDateSelection(),
          _buildTheaterList(),
        ],
      ),
    );
  }

  Widget _buildMovieHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(movieData['imageUrl']),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, MyColor().darkblue],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieData['name'],
                  style: TextStyle(
                      color: MyColor().white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${movieData['certification']} • ${movieData['language']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return BlocBuilder<TheaterBookingBloc, TheaterBookingState>(
      builder: (context, state) {
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.availableDates.length,
            itemBuilder: (context, index) {
              final date = state.availableDates[index];
              final isSelected = date.day == state.selectedDate.day &&
                  date.month == state.selectedDate.month &&
                  date.year == state.selectedDate.year;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    context.read<TheaterBookingBloc>().add(SelectDate(date));
                  },
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? MyColor().primarycolor : MyColor().transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MyColor().primarycolor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(date),
                          style: TextStyle(
                            color:
                                isSelected ? MyColor().primarycolor :MyColor().primarycolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            color:
                                isSelected ? MyColor().white :MyColor().primarycolor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTheaterList() {
    return BlocBuilder<TheaterBookingBloc, TheaterBookingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        return Expanded(
          child: ListView.builder(
            itemCount: state.theaters.length,
            itemBuilder: (context, index) {
              final theater = state.theaters[index];
              return TheaterCard(
                movieData: movieData,
                screenName: theater.screenName,
                ownerName: theater.ownerName,
                movieId: movieId,
                screenId: theater.screenId,
                ownerId: theater.ownerId,
                selectedDate: state.selectedDate,
              );
            },
          ),
        );
      },
    );
  }
}

class TheaterCard extends StatelessWidget {
  final String screenName;
  final String ownerName;
  final String movieId;
  final String screenId;
  final String ownerId;
  final DateTime selectedDate;
  final Map<String, dynamic> movieData;

  const TheaterCard(
      { super.key,
        required this.screenName,
      required this.ownerName,
      required this.movieId,
      required this.screenId,
      required this.ownerId,
      required this.selectedDate,

      required, required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF134656),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$screenName - $ownerName',
              style: TextStyle(
                  color: MyColor().white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text('More Info',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
           const  SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('owners')
                  .doc(ownerId)
                  .collection('screens')
                  .doc(screenId)
                  .collection('movie_schedules')
                  .doc(movieId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('No showtimes available',
                      style: TextStyle(color: MyColor().white));
                }

                final scheduleData =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (scheduleData == null ||
                    !scheduleData.containsKey('schedules')) {
                  return Text('No schedules available',
                      style: TextStyle(color: MyColor().white));
                }

                final schedules =
                    scheduleData['schedules'] as Map<String, dynamic>;
                final selectedDateString =
                    DateFormat('yyyy-MM-dd').format(selectedDate);

                final matchingDate = schedules.keys.firstWhere(
                  (date) => date.startsWith(selectedDateString),
                  orElse: () => '',
                );

                final showtimes =
                    schedules[matchingDate] as List<dynamic>? ?? [];

                if (showtimes.isEmpty) {
                  return Text(
                      'No showtimes available for ${DateFormat('MMMM d, yyyy').format(selectedDate)}',
                      style: TextStyle(color: MyColor().white));
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: showtimes
                      .map((time) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColor().primarycolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(time.toString(),
                                style: const TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowingSeat(
                                    movieId: movieId,
                                    screenId: screenId,
                                    ownerId: ownerId,
                                    selectedDate: selectedDate,
                                    selectedTime: time.toString(),
                                    movieName: movieData['name'],
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
