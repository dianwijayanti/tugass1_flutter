import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DeleteAnggotaPage {
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final GetStorage _storage = GetStorage();

  Future<bool> deleteAnggotaById(String id) async {
    try {
      final _dio = Dio();
      final _response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_storage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (_response.statusCode == 200) {
        print('Anggota dengan ID $id berhasil dihapus.');
        return true;
      } else {
        print('Gagal menghapus anggota dengan ID $id. Status code: ${_response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error deleting anggota: ${e.response!.data} - ${e.response!.statusCode}');
      } else {
        print('Request failed with exception: $e');
      }
      return false;
    }
  }
}
