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

      print(_response.data);
      if (_response.statusCode == 200) {
        List<Map<String, dynamic>> anggotaList = List<Map<String, dynamic>>.from(_response.data['data']);
        print('success: true, message: Pengambilan daftar anggota sukses');
        for (var anggota in anggotaList) {
          print('ID: ${anggota['id']}, '
                'Nomor Induk: ${anggota['nomor_induk']}, '
                'Nama: ${anggota['nama']}, '
                'Alamat: ${anggota['alamat']}, '
                'Tgl Lahir: ${anggota['tgl_lahir']}, '
                'Telepon: ${anggota['telepon']}, '
                'Image URL: ${anggota['image_url']}, '
                'Status Aktif: ${anggota['status_aktif']}');
        }
        return anggotaList;
      } else {
        print('success: false, message: Gagal mendapatkan daftar anggota. Status code: ${_response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('success: false, message: Error getting list of anggota: ${e.response?.data} - ${e.response?.statusCode}');
      return [];
    }
  }
}
