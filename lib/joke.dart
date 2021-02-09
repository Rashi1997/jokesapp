class Joke {
  final bool error;
  final String setup;
  final String delivery;
  final int id;

  Joke({this.id, this.error, this.setup, this.delivery});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      error: json['error'],
      setup: json['setup'],
      delivery: json['delivery'],
    );
  }
}