import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Ambil data kursi berdasarkan jadwal ID
  Future<List<dynamic>> getSeats(String scheduleId) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/$scheduleId/seats'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data kursi');
    }
  }

  // Fungsi Locking Kursi (Cegah Double Booking)
  Future<bool> lockSeat(String seatId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/seats/lock'),
      body: {'seat_id': seatId},
    );
    return response.statusCode == 200;
  }
}