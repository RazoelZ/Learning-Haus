class Job {
  final int job_id;
  final String position;
  final String description;
  final String salary;
  final String createdAt;
  final String updatedAt;

  Job({
    required this.job_id,
    required this.position,
    required this.description,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      job_id: json['job_id'],
      position: json['position'],
      salary: json['salary'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
