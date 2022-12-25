class Countries {
  final String name;
  final String code;
  Countries ({
    required this.name,
    required this.code,
  });

  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
      name: json['name'],
      code: json['code'],
    );
  }
}