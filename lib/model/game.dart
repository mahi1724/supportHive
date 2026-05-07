class Game {
  final String title;
  final String category;
  final String description;
  final String duration;
  final String difficulty;
  final int likes;
  final int streakPoints;
  final int level;

  Game({
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.likes,
    required this.streakPoints,
    required this.level,
  });
}