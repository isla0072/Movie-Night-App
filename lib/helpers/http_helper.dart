import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String tmdbBaseURL = "https://api.themoviedb.org/3";
  final String movieNightBaseURL = "https://movie-night-api.onrender.com";
  final String tmdbApiKey = "e35880be5483c5a99556ac44807712ee";

  Future<List<dynamic>> fetchMoviesFromTMDB(int page) async {
    final response = await http.get(
        Uri.parse('$tmdbBaseURL/movie/popular?api_key=$tmdbApiKey&page=$page'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception(
          'There was an error when loading the movies: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> startSession(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$movieNightBaseURL/start-session?device_id=$deviceId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'There was an error when starting the session: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'There is no internet connection. Please connect your device and try again.');
    }
  }

  Future<Map<String, dynamic>> joinSession(String deviceId, int code) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$movieNightBaseURL/join-session?device_id=$deviceId&code=$code'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'There was an error when joining the session: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'There is no internet connection. Please connect your device and try again.');
    }
  }

  Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool vote) async {
    try {
      final url = Uri.parse(
          '$movieNightBaseURL/vote-movie?session_id=${Uri.encodeFull(sessionId)}&movie_id=$movieId&vote=$vote');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'There was an error when voting for the movie: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'There is no internet connection. Please connect your device and try again.');
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }
}
