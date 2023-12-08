import 'dart:convert';
import 'package:learning/models/car_models.dart';
import 'package:http/http.dart' as http;

class Repository {
  final _baseURL = 'http://10.0.2.2:8000';

  Future<List<Cars>> getData() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/cars/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          Iterable data = jsonResponse['data'];
          List<Cars> carsList =
              List<Cars>.from(data.map((model) => Cars.fromJson(model)));
          return carsList;
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

  Future<bool> postData(String name, String version, String model) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/cars/'), // Adjust the endpoint if needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'version': version,
          'model': model,
        }),
      );
      if (response.statusCode == 201) {
        // Assuming your API returns a success status or some indicator of success
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
      int carsId, String name, String version, String model) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseURL/cars/$carsId/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'version': version,
          'model': model,
        }),
      );

      // Use 200 status code for successful updates
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error making PUT request: $e');
      return false;
    }
  }

  Future<bool> deleteData(int carsId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseURL/cars/$carsId/'),
        headers: {'Content-Type': 'application/json'},
      );

      // Use 204 status code for successful deletes
      if (response.statusCode == 200) {
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
