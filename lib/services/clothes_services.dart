import 'dart:convert'; 
import 'package:http/http.dart' as http;

class ClothesApi {
 
  static const String baseUrl = "https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes";


  static Future<Map<String, dynamic>> getClothes() async {
    final response = await http.get(Uri.parse(baseUrl));
  
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getClothesById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    return jsonDecode(response.body);
  }

  
  static Future<Map<String, dynamic>> createClothes(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateClothes(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> deleteClothes(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return jsonDecode(response.body);
  }
}
