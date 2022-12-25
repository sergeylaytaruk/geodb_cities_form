class Regions {
  final String name;
  final String countryCode;
  final String isoCode;
  Regions ({
    required this.name,
    required this.countryCode,
    required this.isoCode
  });

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
      name: json['name'],
      countryCode: json['countryCode'],
      isoCode: json['isoCode'],
    );
  }
}