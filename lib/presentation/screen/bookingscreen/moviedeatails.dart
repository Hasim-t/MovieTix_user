import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/screen/bookingscreen/theater_booking.dart';

class MoviesDeatail extends StatelessWidget {
  final DocumentSnapshot movie;

  const MoviesDeatail({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieData = movie.data() as Map<String, dynamic>;
    final movieId = movie.id;
    return MovieDetails(
      movieId: movieId,
      movieData: movieData,
    );
  }
}

class MovieDetails extends StatelessWidget {
  final Map<String, dynamic> movieData;
  final String  movieId;

  MovieDetails({
    Key? key,
    required this.movieData,
    required this.movieId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          movieData['imageUrl'],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movieData['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(movieData['language']),
                                backgroundColor: MyColor().primarycolor,
                              ),
                              SizedBox(width: 8),
                              Chip(
                                label: Text(movieData['category']),
                                backgroundColor: MyColor().primarycolor,
                              ),
                              SizedBox(width: 8),
                              Chip(
                                label: Text(movieData['certification']),
                                backgroundColor: MyColor().primarycolor,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Plot',
                            style: TextStyle(
                              color: MyColor().primarycolor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            movieData['description'],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cast',
                            style: TextStyle(
                              color: MyColor().primarycolor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (movieData['cast'] as List).length,
                              itemBuilder: (context, index) {
                                final cast = (movieData['cast'] as List)[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(cast['imageUrl']),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        cast['actorName'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return TheaterBookingScreen(
                      movieId: movieId,
                      movieData: movieData,
                    );
                  }));
                },
                child: Text('Book Now'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: MyColor().darkblue,
                  backgroundColor: MyColor().primarycolor,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
