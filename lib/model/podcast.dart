class Podcast {
  final String title;
  final String author;
  final String category;
  final String duration;
  final String audioUrl;   // 🔥 REQUIRED for playback
  final String imageUrl;   // optional (for future UI upgrade)
  final bool isNew;

  Podcast({
    required this.title,
    required this.author,
    required this.category,
    required this.duration,
    required this.audioUrl,
    this.imageUrl = '',
    this.isNew = false,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      duration: json['duration'] ?? '',
      audioUrl: json['audioUrl'] ?? '',   // 🔥 important
      imageUrl: json['imageUrl'] ?? '',
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'duration': duration,
      'audioUrl': audioUrl,   // 🔥 important
      'imageUrl': imageUrl,
      'isNew': isNew,
    };
  }
}