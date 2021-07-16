import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/widgets/widgets.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    required this.movies,
    required this.onNextPage,
    this.title
  });
  

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      //color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: (this.widget.title != null) ? Text(
              this.widget.title!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ) : null,
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) {
                final _movie = widget.movies[index];
                return _MoviewPoster(movie: _movie);
              }
            ),
          )
        ],
      ),
    );
  }
}

class _MoviewPoster extends StatelessWidget {

  final Movie movie;

  const _MoviewPoster({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'slider-${movie.id}';

    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.urlImage),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Text(
            movie.overview,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}