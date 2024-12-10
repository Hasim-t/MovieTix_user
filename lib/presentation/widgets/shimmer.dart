import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/movie/bloc/movie_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/moviedeatails.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';


Widget buildCarouselShimmer() {
  return Shimmer.fromColors(
    baseColor: MyColor().shimmerBaseColor,
    highlightColor: MyColor().shimmerHighlightColor,
    child:  SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin:const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor().shimmerBaseColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColor().shimmerBaseColor,
                      borderRadius:
                    const      BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 15,
                          color: MyColor().shimmerBaseColor,
                        ),
                       const  SizedBox(height: 5),
                        Container(
                          width: 100,
                          height: 10,
                          color:MyColor().shimmerBaseColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Widget buildMovieCardShimmer() {
 

  return Shimmer.fromColors(
    baseColor: MyColor(). shimmerBaseColor,
    highlightColor: MyColor(). shimmerHighlightColor,
    child: Card(
      color: MyColor(). shimmerBaseColor,
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
            flex: 4,
            child: Container(
              color: MyColor().shimmerBaseColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 16,
              color: MyColor().shimmerBaseColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: MyColor().shimmerBaseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
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
          child: CachedNetworkImage(
            imageUrl: data['imageUrl'],
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: MyColor().shimmerBaseColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: MyColor().darkblue,
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('Book'),
          ),
        ),
      ],
    ),
  );
}
Widget buildMovieList(BuildContext context, MovieState state) {
  final filteredMovies = context.read<MovieBloc>().filteredMovies;

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
                  controller: PageController(initialPage: state.currentCarouselPage),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.malayalamMovies.length > 3 ? 3 : state.malayalamMovies.length,
                  onPageChanged: (int page) {
                    context.read<MovieBloc>().add(UpdateCarouselPage(page));
                  },
                  itemBuilder: (context, index) {
                    final movie = state.malayalamMovies[index];
                    final data = movie.data() as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: data['imageUrl'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: MyColor().shimmerBaseColor,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: MyColor().shimmerBaseColor,
                                child: Icon(Icons.error, color: MyColor().primarycolor),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => buildMovieCard(filteredMovies[index], context),
            childCount: filteredMovies.length,
          ),
        ),
      ),
    ],
  );
}