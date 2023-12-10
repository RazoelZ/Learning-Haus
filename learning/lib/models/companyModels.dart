class Company {
  final int company_id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Company({
    required this.company_id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      company_id: json['company_id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
