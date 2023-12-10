import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/userModels.dart';
import 'package:learning/constant.dart';

class Repository {
  Future<List<User>> getUserData() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users'));
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
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<User> Login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$baseURL/login'),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = json.decode(response.body);
        if (jsonresponse['status'] == 'success') {
          User user = User.fromJson(jsonresponse['data']);
          return user;
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

  Future<bool> DeleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseURL/user/$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = json.decode(response.body);
        if (jsonresponse['status'] == 'success') {
          return true;
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
