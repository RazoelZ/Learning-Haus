import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/companyModels.dart';
import 'package:learning/models/userModels.dart';
import 'package:learning/constant.dart';

class RepositoryCompanies {
  Future<List<Company>> getCompaniesData() async {
    var response = await http.get(Uri.parse('$baseURL/companies'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonresponse = json.decode(response.body);
      if (jsonresponse['status'] == 'success') {
        Iterable data = jsonresponse['data'];
        List<Company> companies =
            List<Company>.from(data.map((e) => Company.fromJson(e)));
        return companies;
      } else {
        throw Exception(
            'API request failed with status: ${jsonresponse['status']}');
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  Future<List<User>> getFilteredEmployee(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseURL/employeebycompanies?id=$id'));
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

  Future<bool> changeCompany(int id, int idcompany) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/user/changecompany/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'company_id': idcompany}),
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
