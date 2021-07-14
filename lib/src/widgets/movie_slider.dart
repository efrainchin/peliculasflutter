import 'package:flutter/material.dart';

class MovieSlider extends StatelessWidget {

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
            child: Text(
              'Populares',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20,
              itemBuilder: (_, int index) =>_MoviewPoster()
            ),
          )
        ],
      ),
    );
  }
}

class _MoviewPoster extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.popAndPushNamed(context, 'details', arguments: 'movie-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage('https://via.placeholder.com/300x400'),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5,),
          Text(
            'Startwars: ejemplo de peliculas para la app de flutter',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}