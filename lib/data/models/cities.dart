class Cities {
  final String id;
  final String name;
  Cities ({
    required this.id,
    required this.name,
  });

  factory Cities.fromJson(Map<String, dynamic> json) {
    return Cities(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}