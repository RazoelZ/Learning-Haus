class DetailUser {
  final int id;
  final String name;
  final String email;
  final String tanggal_masuk;
  final String job;
  final String salary;
  final String company;

  DetailUser({
    required this.id,
    required this.name,
    required this.email,
    required this.tanggal_masuk,
    required this.salary,
    required this.job,
    required this.company,
  });

  factory DetailUser.fromJson(Map<String, dynamic> json) {
    return DetailUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      tanggal_masuk: json['tanggal_masuk'],
      job: json['job'],
      salary: json['salary'],
      company: json['company'],
    );
  }
}
