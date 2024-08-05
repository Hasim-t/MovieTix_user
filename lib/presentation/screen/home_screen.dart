import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/movie/bloc/movie_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/moviedeatails.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: Row(
          children: [
            Image.asset(
              'asset/movietix_logo.png',
              height: 70,
              width: 70,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Movies',
              style: TextStyle(fontFamily: 'Cabin', fontSize: 22),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state.movies.isNotEmpty) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Malayalam Movies',
                          style: TextStyle(
                            fontFamily: 'Cabin',
                            fontSize: 22,
                            color: MyColor().primarycolor,
                          ),
                        ),
                      ),
                      if (state.malayalamMovies.isNotEmpty)
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: PageController(
                                initialPage: state.currentCarouselPage),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.malayalamMovies.length > 3
                                ? 3
                                : state.malayalamMovies.length,
                            onPageChanged: (int page) {
                              context
                                  .read<MovieBloc>()
                                  .add(UpdateCarouselPage(page));
                            },
                            itemBuilder: (context, index) {
                              final movie = state.malayalamMovies[index];
                              final data = movie.data() as Map<String, dynamic>;
                              return Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(data['imageUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8),
                                              Colors.transparent
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          data['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
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
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => buildMovieCard(state.movies[index], context),
                      childCount: state.movies.length,
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(child: Text('No movies available.'));
        },
      ),
    );
  }

  Widget buildMovieCard(DocumentSnapshot movie, BuildContext context) {
    final data = movie.data() as Map<String, dynamic>;
    return Card(
      color: MyColor().primarycolor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
          bottom: Radius.circular(8),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              data['imageUrl'],
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['name'],
              style: TextStyle(
                fontFamily: 'Cabin',
                color: MyColor().darkblue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MoviesDeatail(movie: movie);
                }));
              },
              child: Text('Book'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: MyColor().darkblue,
                minimumSize: Size(double.infinity, 36), // makes the button wide
              ),
            ),
          ),
        ],
      ),
    );
  }
}


