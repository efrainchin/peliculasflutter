import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/provides/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {

  final int? movieId;

  const CastingCard({
    this.movieId
  });

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId!),
      builder: (_, AsyncSnapshot<List<Cast>> snapShot) {

        if(!snapShot.hasData) {
          return Container(
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final cast = snapShot.data!;

        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          //color: Colors.red,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) {
              final actor = cast[index];
              return _CastCard(actor: actor,);
            }
          ),
        );
      }
    );

  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({
    required this.actor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      //color: Colors.green,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.urlImage),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5,),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}