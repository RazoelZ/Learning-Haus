import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/book_models.dart';

class RepositoryBooks {
  final _baseURL = 'http://10.0.2.2:4005/api';

  Future<List<Books>> getData() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/books'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          Iterable data = jsonResponse['data'];
          List<Books> booksList =
              List<Books>.from(data.map((model) => Books.fromJson(model)));
          return booksList;
        } else {
          throw Exception(
              'API request failed with status: ${jsonResponse['status']}');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load data: $e');
    }
  }

  Future<bool> postData(String author, String title, String publisher) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/createbooks/'), // Adjust the endpoint if needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'author': author,
          'title': title,
          'publisher': publisher,
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error making POST request: $e');
      return false;
    }
  }

  Future<bool> putData(
      int id, String author, String title, String publisher) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseURL/updatebooks/$id/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'author': author,
          'title': title,
          'publisher': publisher,
        }),
      );
      if (response.statusCode == 200) {
        // Assuming your API returns a success status or some indicator of success
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error making PUT request: $e');
      return false;
    }
  }

  Future<bool> deleteData(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseURL/deletebooks/$id/'),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      if (response.statusCode == 204) {
        // Assuming your API returns a success status or some indicator of success
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error making DELETE request: $e');
      return false;
    }
  }
}
