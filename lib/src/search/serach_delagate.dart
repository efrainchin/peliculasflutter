import 'package:flutter/material.dart';
import 'package:peliculas/src/models/movie.dart';
import 'package:peliculas/src/provides/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSeachDelegate extends SearchDelegate {

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar ..';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) { 
    if (query.isEmpty)
      return _emptyContainer();

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSuggestionsQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }

        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index ) => _MovieItem(movie: movies[index])
        );
      }
    );
  }

  _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100),
      ),
    );
  }

}

class _MovieItem extends StatelessWidget {
  
  final Movie movie;

  const _MovieItem({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Container(
        margin: EdgeInsets.all(5),
        child: Hero(
          tag: movie.heroId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: FadeInImage(
              height: 60,
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(movie.urlImage)
            ),
          ),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.overview, overflow: TextOverflow.ellipsis, maxLines: 3,),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}