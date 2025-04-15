import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_page.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.19:5000';

  static Future<void> addTransaction({
    required String title,
    required int amount,
    required String type,
    required DateTime date,
    required String time,
  }) async {
    final url = Uri.parse('$baseUrl/transaksi');
    final body = jsonEncode({
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'time': time,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal simpan ke server: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error kirim data ke server: $e');
    }
  }

  static Future<List<Transaction>> getTransactions() async {
    final url = Uri.parse('$baseUrl/transaksi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => Transaction.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error ambil data dari server: $e');
    }
  }
}