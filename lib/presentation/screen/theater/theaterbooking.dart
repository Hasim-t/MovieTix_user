import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/showing_seat.dart';

class TheaterMovieshowing extends StatelessWidget {
  final String theaterId;
  final String theaterName;

  const TheaterMovieshowing({
    super.key,
    required this.theaterId,
    required this.theaterName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: Text(
          theaterName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
         
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('owners')
                  .doc(theaterId)
                  .collection('screens')
                  .snapshots(),
              builder: (context, screensSnapshot) {
                if (screensSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (screensSnapshot.hasError) {
                  return Center(child: Text("Error: ${screensSnapshot.error}"));
                }
                if (!screensSnapshot.hasData ||
                    screensSnapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text("No screens found for this theater"));
                }

                return ListView.builder(
                  itemCount: screensSnapshot.data!.docs.length,
                  itemBuilder: (context, screenIndex) {
                    var screenDoc = screensSnapshot.data!.docs[screenIndex];
                    var screenId = screenDoc.id;

                    return _buildMovieList(screenId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMovieList(String screenId) {
  // Get the current date and time
  final now = DateTime.now();

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
       .collection('owners')
       .doc(theaterId)
       .collection('screens')
       .doc(screenId)
       .collection('movie_schedules')
       .snapshots(),
    builder: (context, moviesSnapshot) {
      if (moviesSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (moviesSnapshot.hasError) {
        return Center(child: Text("Error: ${moviesSnapshot.error}"));
      }
      if (!moviesSnapshot.hasData || moviesSnapshot.data!.docs.isEmpty) {
        return Center(child: Text("No movies found for this screen"));
      }

      // Filter movies based on the current date
      final futureMovies = moviesSnapshot.data!.docs.where((movieSchedule) {
        var movieScheduleData = movieSchedule.data() as Map<String, dynamic>;
        var schedules = movieScheduleData['schedules'] as Map<String, dynamic>;
        // Check if any schedule is in the future
        return schedules.keys.any((dateString) {
          var date = DateTime.parse(dateString);
          return date.isAfter(now) || date.isAtSameMomentAs(now);
        });
      }).toList();

      if (futureMovies.isEmpty) {
        return Center(child: Text("No future movies found for this screen"));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Screen $screenId",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ...futureMovies.map((movieSchedule) {
            var movieScheduleData = movieSchedule.data() as Map<String, dynamic>;
            var movieId = movieScheduleData['movie_id'] as String;
            var schedules = movieScheduleData['schedules'] as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                 .collection('movies')
                 .doc(movieId)
                 .get(),
              builder: (context, movieSnapshot) {
                if (movieSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var movieData = movieSnapshot.data?.data() as Map<String, dynamic>?;
                var movieName = movieData?['name'] ?? 'Unknown Movie';
                var imageUrl = movieData?['imageUrl'] ?? "asset/photo_icons.png";
                var language = movieData?['language'] ?? 'Unknown';

                return Card(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.network(imageUrl, width: 80, height: 120, fit: BoxFit.cover),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movieName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(language, style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: schedules.entries.map((entry) {
                                  var dateString = entry.key;
                                  var times = entry.value as List<dynamic>;
                                  var date = DateTime.parse(dateString);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dateString, style: TextStyle(color: Colors.white)),
                                      Wrap(
                                        spacing: 8,
                                        children: times.map((time) => _buildTimeChip(
                                          context,
                                          time.toString(),
                                          movieId,
                                          screenId,
                                          date,
                                          movieName,
                                        )).toList(),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      );
    },
  );
}


  Widget _buildTimeChip(BuildContext context, String time, String movieId, String screenId, DateTime date, String movieName) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShowingSeat(
            movieId: movieId,
            screenId: screenId,
            ownerId: theaterId,
            selectedDate: date,
            selectedTime: time,
            movieName: movieName,
          ),
        ),
      );
    },
    child: Chip(
      label: Text(time, style: TextStyle(color: Colors.white)),
      backgroundColor: MyColor().primarycolor,
    ),
  );
}
}
