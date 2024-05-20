import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ListAllAnggota {
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final GetStorage _storage = GetStorage();

  Future<List<Map<String, dynamic>>> getAllAnggota() async {
    try {
      final _dio = Dio();
      final _response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_storage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (_response.statusCode == 200) {
        print('Berhasil mendapatkan daftar anggota.');
        return List<Map<String, dynamic>>.from(_response.data['data']);
      } else {
        print('Gagal mendapatkan daftar anggota. Status code: ${_response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('Error getting list of anggota: ${e.response?.data} - ${e.response?.statusCode}');
      return [];
    }
  }
}
