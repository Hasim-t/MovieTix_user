import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/screen/theater/theaterbooking.dart';


class TheaterScreen extends StatelessWidget {
  const TheaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColor().primarycolor,
        title: const Text(
          "All Theaters",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
             
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('owners').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No theaters found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var theaterDoc = snapshot.data!.docs[index];
              var theaterData = theaterDoc.data() as Map<String, dynamic>;
              var theaterName = theaterData['name'] ?? 'Unnamed Theater';
             
              var imageUrl = theaterData['profileImageUrl'] as String?;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TheaterMovieshowing(
                        theaterId: theaterDoc.id,
                        theaterName: theaterName,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey,
                                  child: const Center(child: Icon(Icons.error)),
                                );
                              },
                            )
                          : Container(
                              height: 150,
                              width: 500,
                              color: Colors.grey,
                              child: Image.network(
                                fit: BoxFit.contain,
                                'https://t3.ftcdn.net/jpg/03/74/28/58/240_F_374285858_KzJ88FysqJ79AhyNPW2lqnBtsRTokuav.jpg',
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theaterName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Row(
                              //   children: [
                              //     Icon(Icons.location_on, color: Colors.white, size: 16),
                              //     SizedBox(width: 4),
                              //     Text(
                              //      '',
                              //       style: TextStyle(color: Colors.white, fontSize: 14),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}