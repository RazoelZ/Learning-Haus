import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/jobModels.dart';
import 'package:learning/constant.dart';

class RepositoryJobs {
  Future<List<Job>> getJobsData() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/jobs'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = json.decode(response.body);
        if (jsonresponse['status'] == 'success') {
          Iterable data = jsonresponse['data'];
          List<Job> jobs = List<Job>.from(data.map((e) => Job.fromJson(e)));
          return jobs;
        } else {
          throw Exception(
              'API request failed with status: ${jsonresponse['status']}');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
