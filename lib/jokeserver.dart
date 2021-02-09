import 'dart:convert';

import 'package:jokesapp/joke.dart';
import 'package:http/http.dart' as http;

class JokeServer {
  final dadJokeApi = 'https://sv443.net/jokeapi/v2/joke/Any?type=twopart';
  final httpHeaders = const {
    'Accept': 'application/json',
  };

  Future<Joke> fetchJoke() async {
    try {
      final response = await http.get(dadJokeApi);
      if (response.statusCode == 200) {
        return Joke.fromJson(json.decode(response.body));
      } else {
        return Joke(setup: 'Failed to load joke.', delivery: 'Failed to load joke.', id: 0, error: true);
      }
    } catch (exception) {
      return Joke(setup: 'Network error occurred.', delivery: 'Network error occurred.', id: 0, error: true);
    }
  }
}