import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/companyModels.dart';
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
}
