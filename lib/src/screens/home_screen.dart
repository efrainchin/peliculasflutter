import 'package:flutter/material.dart';
import 'package:peliculas/src/provides/movies_provider.dart';
import 'package:peliculas/src/search/serach_delagate.dart';
import 'package:peliculas/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSeachDelegate()
            ), 
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onMovies,),
            MovieSlider(
              movies: moviesProvider.onPopulars,
              title: 'Populares..',
              onNextPage: () => moviesProvider.getPopularMovies(),
            )
          ],
        ),
      ),
    );
  }
}