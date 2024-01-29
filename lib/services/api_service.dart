import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
 // final String baseUrl = 'http://10.0.2.2:3000'; android studio
  final String baseUrl = 'http://Localhost:3000';
  Future<http.Response> get(String endpoint) async {
    return await http.get(Uri.parse('$baseUrl$endpoint'));
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    return await http.delete(Uri.parse('$baseUrl$endpoint'));
  }
}
