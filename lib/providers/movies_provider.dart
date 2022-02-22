import 'package:films/models/models.dart';
import 'package:films/models/search_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiKey = "133bb059bc4f9131453a67e00a89d534";
  final String _language = "es-ES";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;
  Map<int, List<Cast>> movieCast = {};

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final Uri url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getNowPlayingMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    final jsonData = await _getJsonData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final Uri url = Uri.https(_baseUrl, '/3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }
}
