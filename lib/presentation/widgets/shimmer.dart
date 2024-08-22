import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/moviedeatails.dart';
import 'package:shimmer/shimmer.dart';


Widget buildCarouselShimmer() {
  return Shimmer.fromColors(
    baseColor: MyColor().shimmerBaseColor,
    highlightColor: MyColor().shimmerHighlightColor,
    child: Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 10),
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
                         BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 15,
                          color: MyColor().shimmerBaseColor,
                        ),
                        SizedBox(height: 5),
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
              child:  Text('Book'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: MyColor().darkblue,
                minimumSize: Size(double.infinity, 36),
              ),
            ),
          ),
        ],
      ),
    );
  }