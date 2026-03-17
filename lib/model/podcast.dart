class Podcast {
  final String title;
  final String author;
  final String category;
  final String duration;
  final bool isNew;

  Podcast({
    required this.title,
    required this.author,
    required this.category,
    required this.duration,
    this.isNew = false,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      duration: json['duration'] ?? '',
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'duration': duration,
      'isNew': isNew,
    };
  }
}
