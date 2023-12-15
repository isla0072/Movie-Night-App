import 'package:finalflutter/helpers/http_helper.dart';
import 'package:finalflutter/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finalflutter/helpers/preferences_helper.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<Map<String, dynamic>> movies = [];
  int currentPage = 1;
  bool isLoading = true;
  String? sessionId;
  String? deviceId;
  final HttpHelper httpHelper = HttpHelper();
  int currentMovieIndex = 0;

  @override
  void initState() {
    super.initState();
    _initSession();
    _fetchMovies();
  }

  Future<void> _initSession() async {
    sessionId = await PreferencesHelper.getSessionId();
    deviceId = await PreferencesHelper.getDeviceId();
    if (sessionId == null || deviceId == null) {
      if (kDebugMode) {
        print(
            'Either the session Id or the device Id is null. Please try again.');
      }
      return;
    }
  }

  Future<void> _fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<dynamic> movieResults =
          await httpHelper.fetchMoviesFromTMDB(currentPage);
      final List<Map<String, dynamic>> newMovies =
          movieResults.cast<Map<String, dynamic>>();

      setState(() {
        movies.addAll(newMovies);
        currentPage++;
      });
    } catch (e) {
      if (kDebugMode) {
        print('There was an error fetching the movies: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _voteMovie(int movieId, bool vote) async {
    try {
      final responseData =
          await httpHelper.voteMovie(sessionId!, movieId, vote);
      var matchFound = responseData['data']['match'] as bool;
      var votedMovieId = responseData['data']['movie_id'].toString();
      if (!mounted) return;
      if (matchFound) {
        if (kDebugMode) {
          print('There was a match found.');
        }
        _showMatchDialog(votedMovieId);
      } else {
        if (kDebugMode) {
          print('No match was found.');
        }
      }
      _loadNextMovie();
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when voting for the movie: $e');
      }
    }
  }

  void _loadNextMovie() {
    setState(() {
      currentMovieIndex++;
      if (currentMovieIndex >= movies.length) {
        currentMovieIndex = 0;
        _fetchMovies();
      }
    });
  }

  Future<void> _showMatchDialog(dynamic matchedMovieId) async {
    Map<String, dynamic>? matchedMovie = movies.firstWhere(
        (movie) => movie['id'].toString() == matchedMovieId.toString(),
        orElse: () => {});

    final TextStyle? headlineMedium =
        Theme.of(context).textTheme.headlineMedium;
    final TextStyle? bodyMedium = Theme.of(context).textTheme.bodyMedium;
    String movieTitle = matchedMovie['title'] ?? 'Unknown Title';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            '$movieTitle is the winner!',
            style: headlineMedium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    matchedMovie['poster_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${matchedMovie['poster_path']}'
                        : "assets/images/poster.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$movieTitle is the matching movie',
                    style: bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MyColors.secondaryColor,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Movie Selection')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Choices')),
      body: movies.isNotEmpty && currentMovieIndex < movies.length
          ? Center(
              child: Dismissible(
                key: Key(movies[currentMovieIndex]['id'].toString()),
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: const Icon(Icons.thumb_up,
                      color: Colors.green, size: 36.0),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.center,
                  child: const Icon(Icons.thumb_down,
                      color: Colors.red, size: 36.0),
                ),
                onDismissed: (direction) {
                  bool vote =
                      direction == DismissDirection.endToStart ? false : true;
                  int movieId =
                      int.parse(movies[currentMovieIndex]['id'].toString());
                  _voteMovie(movieId, vote);
                },
                child: MovieCard(movie: movies[currentMovieIndex]),
              ),
            )
          : const Center(child: Text('No movies available')),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextStyle? bodySmall = Theme.of(context).textTheme.bodySmall;
    final TextStyle? headlineMedium =
        Theme.of(context).textTheme.headlineMedium;

    return Card(
      color: MyColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            movie['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                : "assets/images/poster.png",
            width: 300,
            height: 450,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  movie['title'],
                  style: headlineMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Release Date: ${movie['release_date']}',
                    style: bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie['overview'],
              style: bodySmall,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
