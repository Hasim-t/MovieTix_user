import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:intl/intl.dart';

class TheaterMovieshowing extends StatelessWidget {
  final String theaterId;
  final String theaterName;

  const TheaterMovieshowing({
    Key? key,
    required this.theaterId,
    required this.theaterName,
  }) : super(key: key);

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
          _buildDateSelector(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('owners')
                  .doc(theaterId)
                  .collection('screens')
                  .snapshots(),
              builder: (context, screensSnapshot) {
                if (screensSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (screensSnapshot.hasError) {
                  return Center(child: Text("Error: ${screensSnapshot.error}"));
                }
                if (!screensSnapshot.hasData || screensSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No screens found for this theater"));
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

  Widget _buildDateSelector() {
    final now = DateTime.now();
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Chip(
              label: Text(
                DateFormat('EEE\nd').format(date),
                textAlign: TextAlign.center,
              ),
              backgroundColor: index == 0 ? MyColor().primarycolor : Colors.grey,
            ),
          );
        },
      ),
    );
  }
Widget _buildMovieList(String screenId) {
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
        return SizedBox(); // Don't show anything if no movies
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Screen $screenId",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...moviesSnapshot.data!.docs.map((movieDoc) {
            var movieData = movieDoc.data() as Map<String, dynamic>;
            var movieName = movieData['name'] ?? 'Unnamed Movie';
            var movieImageUrl = movieData['imageUrl'] as String?;
            var language = movieData['language'] ?? 'Unknown';

            return Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (movieImageUrl != null)
                      Image.network(movieImageUrl, width: 80, height: 120, fit: BoxFit.cover)
                    else
                      Container(width: 80, height: 120, color: Colors.grey),
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
                            children: [
                              _buildTimeChip('7:30 pm'),
                              _buildTimeChip('9:45 pm'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    },
  );
}
  Widget _buildTimeChip(String time) {
    return Chip(
      label: Text(time, style: TextStyle(color: Colors.white)),
      backgroundColor: MyColor().primarycolor,
    );
  }
}