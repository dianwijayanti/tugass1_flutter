import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class GetAnggotaDetails {
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final GetStorage _storage = GetStorage();

  Future<Map<String, dynamic>?> getAnggotaDetailsById(String id) async {
    try {
      final _dio = Dio();
      final _response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_storage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      print(_response.data);
      if (_response.statusCode == 200) {
        Map<String, dynamic> anggotaDetails = Map<String, dynamic>.from(_response.data['data']);
        return anggotaDetails;
      } else {
          print('Gagal mendapatkan detail anggota. Status code: ${_response.statusCode}');
          return null;
        }
      } catch (e) {
      print('Terjadi kesalahan saat mengambil detail anggota: $e');
      return null;
    }
  }
}