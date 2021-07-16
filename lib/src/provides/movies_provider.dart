

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/helpers/debouncer.dart';
import 'package:peliculas/src/models/models.dart';
import 'dart:convert' as convert;

import 'package:peliculas/src/models/now_playing_response.dart';
import 'package:peliculas/src/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = 'f7c6b146fff9c605de581dfa8ce762d6';
  String _language = 'es-MX';

  List<Movie> onMovies = [];
  List<Movie> onPopulars = [];
  int _popularPage =0;

  Map<int, List<Cast>> moviesCast =  {};

  final debouncer = Debouncer(
    duration: Duration(microseconds: 600)
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider() {
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _baseJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page'
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    var data = await this._baseJsonData('3/movie/now_playing');

    final nowPlayingResponse =  NowPlayingResponse.fromJson(data);
    onMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    var data = await this._baseJsonData('3/movie/popular', _popularPage);
    final popularsResponse =  PopularResponse.fromJson(data);
    onPopulars = popularsResponse.results;

    onPopulars = [...onPopulars, ...popularsResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if(moviesCast.containsKey(movieId))
      return moviesCast[movieId]!;
    final data = await this._baseJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(data);
    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    
    return searchResponse.results;
  }

  void getSuggestionsQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchMovie(query);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(microseconds:  300), (_) {
      debouncer.value = query;
     });

     Future.delayed(Duration(microseconds: 301)).then((_) => timer.cancel());
  }
}