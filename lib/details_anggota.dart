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
        // Check if 'success' is true and 'data' is not null in the response
        if (_response.data['success'] == true &&
            _response.data['data'] != null) {
          // Extract the 'anggota' details from 'data'
          Map<String, dynamic> anggotaDetails =
              Map<String, dynamic>.from(_response.data['data']['anggota']);

          // Adjust the 'is_active' field to a boolean
          anggotaDetails['status_aktif'] =
              anggotaDetails['is_active'] == '1' ? true : false;

          return anggotaDetails;
        } else {
          print(
              'Gagal mendapatkan detail anggota. Response: ${_response.data}');
          return null;
        }
      } else {
        print(
            'Gagal mendapatkan detail anggota. Status code: ${_response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil detail anggota: $e');
      return null;
    }
  }
}
