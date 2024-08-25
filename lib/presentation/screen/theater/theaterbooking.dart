import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import
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
        elevation: 0,
        title: Text(
          theaterName,
          style: TextStyle(
            fontFamily: 'Cabin',
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

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
                if (screensSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (screensSnapshot.hasError) {
                  return Center(child: Text("Error: ${screensSnapshot.error}"));
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
    final now = DateTime.now();
    final nowDateOnly = DateTime(now.year, now.month, now.day); // Current date with time set to midnight

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
          return Center(child:  CircularProgressIndicator());
        }
        if (moviesSnapshot.hasError) {
          return Center(child: Text("Error: ${moviesSnapshot.error}"));
        }
        if (!moviesSnapshot.hasData || moviesSnapshot.data!.docs.isEmpty) {
          return Center(child: Text("No movies found for this screen", style: TextStyle(color: Colors.white)));
        }

        final futureMovies = moviesSnapshot.data!.docs.where((movieSchedule) {
          var movieScheduleData = movieSchedule.data() as Map<String, dynamic>;
          var schedules = movieScheduleData['schedules'] as Map<String, dynamic>;

          return schedules.keys.any((dateString) {
            try {
              var date = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateString);
              return date.isAfter(nowDateOnly) || date.isAtSameMomentAs(nowDateOnly);
            } catch (e) {
      
              return false;
            }
          });
        }).toList();

        if (futureMovies.isEmpty) {
          return Center(child: Text("", style: TextStyle(color: Colors.white)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                "Screen $screenId",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...futureMovies.map((movieSchedule) {
              var movieScheduleData = movieSchedule.data() as Map<String, dynamic>;
              var movieId = movieScheduleData['movie_id'] as String;
              var schedules = movieScheduleData['schedules'] as Map<String, dynamic>;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('movies').doc(movieId).get(),
                builder: (context, movieSnapshot) {
                  if (movieSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var movieData = movieSnapshot.data?.data() as Map<String, dynamic>?;
                  var movieName = movieData?['name'] ?? 'Unknown Movie';
                  var imageUrl = movieData?['imageUrl'] ?? "asset/photo_icons.png";
                  var language = movieData?['language'] ?? 'Unknown';

                  return Card(
                    color: MyColor().darkblue.withOpacity(0.85),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movieName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  language,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: schedules.entries.map((entry) {
                                    var dateString = entry.key;
                                    var times = entry.value as List<dynamic>;
                                    try {
                                      var date = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateString);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(date),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 8,
                                            children: times.where((time) {
                                              try {
                                                var dateTimeString = '$dateString $time';
                                                var timeDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateTimeString);
                                                return timeDate.isAfter(now) || timeDate.isAtSameMomentAs(now);
                                              } catch (e) {
                                                return false;
                                              }
                                            }).map((time) => _buildTimeChip(
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
                                    } catch (e) {
                                      return Container();
                                    }
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
        label: Text(
          time,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: MyColor().primarycolor,
        elevation: 3,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
