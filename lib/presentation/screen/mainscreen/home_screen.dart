import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/movie/bloc/movie_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/widgets/shimmer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}
class _HomescreenState extends State<Homescreen> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontFamily: 'Cabin', fontSize: 22),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : Row(
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
                _searchController.clear();
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.isLoading) {
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
                      buildCarouselShimmer(),
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
                      (context, index) => buildMovieCardShimmer(),
                      childCount: 6,
                    ),
                  ),
                ),
              ],
            );
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state.movies.isNotEmpty) {
            final filteredMovies = _searchQuery.isEmpty
                ? state.movies
                : state.movies.where((movie) {
                    final data = movie.data() as Map<String, dynamic>;
                    final name = data['name'].toString().toLowerCase();
                    return name.contains(_searchQuery.toLowerCase());
                  }).toList();
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
                                        padding:  EdgeInsets.all(8),
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
                      (context, index) =>
                          buildMovieCard(filteredMovies[index], context),
                      childCount: filteredMovies.length,
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
}
