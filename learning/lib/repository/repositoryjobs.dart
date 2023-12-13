import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/jobModels.dart';
import 'package:learning/constant.dart';
import 'package:learning/models/userModels.dart';

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

  Future<List<User>> getFilteredEmployee(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseURL/employeebyjobs?id=$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = json.decode(response.body);
        if (jsonresponse['status'] == 'success') {
          Iterable data = jsonresponse['data'];
          List<User> users = List<User>.from(data.map((e) => User.fromJson(e)));
          return users;
        } else {
          throw Exception(
              'API request failed with status: ${jsonresponse['status']}');
        }
      } else {
        throw Exception(
            'API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<bool> changeJob(int id, int idJob) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/user/changejob/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'job_id': idJob}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          throw Exception(
              'API request failed with status: ${jsonResponse['status']}');
        }
      } else {
        throw Exception(
            'API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
