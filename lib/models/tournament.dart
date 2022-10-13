class Tournament {
  final int id;
  final String name;
  final int startDate;
  final int endDate;
  final String photoUrl;
  final bool enrolled;

  const Tournament(
      {required this.name,
      required this.id,
      required this.startDate,
      required this.endDate,
      required this.photoUrl,
      required this.enrolled});

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
        name: json['name'],
        id: json['id'],
        photoUrl: json['meta']['ui']['games_image']['url'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        enrolled: json['enrolled']);
  }
}
