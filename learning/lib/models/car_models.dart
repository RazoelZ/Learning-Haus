class Cars {
  final int carsId;
  final String name;
  final String version;
  final String model;

  Cars({
    required this.carsId,
    required this.name,
    required this.version,
    required this.model,
  });

  factory Cars.fromJson(Map<String, dynamic> json) {
    return Cars(
      carsId: json['carsId'],
      name: json['name'],
      version: json['version'],
      model: json['model'],
    );
  }
}
