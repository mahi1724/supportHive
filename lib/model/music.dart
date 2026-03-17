class Music {
  final String title;
  final String category;
  final String duration;

  Music({
    required this.title,
    required this.category,
    required this.duration,
  });

  String get subtitle => '$category • $duration';

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'duration': duration,
    };
  }
}