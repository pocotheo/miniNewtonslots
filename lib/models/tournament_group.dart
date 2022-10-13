class TournamentGroup {
  final int id;
  final String name;
  final int priority;
  final List tournaments;

  const TournamentGroup(
      {required this.name,
      required this.id,
      required this.priority,
      required this.tournaments});

  factory TournamentGroup.fromJson(Map<String, dynamic> json) {
    return TournamentGroup(
        name: json['name'],
        id: json['id'],
        priority: json['priority'],
        tournaments: json['tournaments']);
  }
}
