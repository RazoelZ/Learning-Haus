class User {
  final int id;
  final String name;
  final String email;
  final int role;
  final String password;
  final int job_id;
  final int company_id;
  final String created_at;
  final String updated_at;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    required this.job_id,
    required this.company_id,
    required this.created_at,
    required this.updated_at,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
      job_id: json['job_id'],
      company_id: json['company_id'],
      created_at: json['createdAt'],
      updated_at: json['updatedAt'],
    );
  }
}
