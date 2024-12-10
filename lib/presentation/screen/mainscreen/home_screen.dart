import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/business_logic/blocs/movie/bloc/movie_bloc.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/mainscreen/gemini_screen.dart';
import 'package:movie/presentation/widgets/shimmer.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final List<String> languages = [
    'All',
    'English',
    'Malayalam',
    'Telugu',
    'Tamil',
    'Kannada',
    'Hindi'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listener: (context, state) {
        if (state.isSearching) {}
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColor().darkblue,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: MyColor().primarycolor,
            title: state.isSearching
                ? TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search movies...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontFamily: 'Cabin', fontSize: 22),
                    onChanged: (query) {
                      context.read<MovieBloc>().add(SearchMovies(query));
                    },
                  )
                : Row(
                    children: [
                      Image.asset(
                        'asset/movietix_logo.png',
                        height: 70,
                        width: 70,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Movies',
                        style: TextStyle(fontFamily: 'Cabin', fontSize: 22),
                      ),
                    ],
                  ),
            actions: [
          GestureDetector(
            onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GeminiScreen();
    }));
            },
            child: Image.asset('asset/Gemini png.png')),
              IconButton(
                onPressed: () {
                  context.read<MovieBloc>().add(ToggleSearch());
                },
                icon: Icon(state.isSearching ? Icons.close : Icons.search),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (String value) {
                  context.read<MovieBloc>().add(FilterMovies(value));
                },
                itemBuilder: (BuildContext context) {
                  return languages.map((String language) {
                    return PopupMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MovieState state) {
    if (state.isLoading) {
      return _buildLoadingView();
    } else if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    } else if (state.movies.isNotEmpty) {
      return buildMovieList(context, state);
    }
    return const Center(child: Text('No movies available.'));
  }

  Widget _buildLoadingView() {
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
  }
}
