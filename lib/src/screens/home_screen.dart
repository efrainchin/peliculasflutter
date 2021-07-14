import 'package:flutter/material.dart';
import 'package:peliculas/src/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(),
            MovieSlider()
          ],
        ),
      ),
    );
  }
}