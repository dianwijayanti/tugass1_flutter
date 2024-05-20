import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class EditAnggotaPage extends StatefulWidget {
  final String id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelepon;
  final bool isActive;

  EditAnggotaPage({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tglLahir,
    required this.noTelepon,
    required this.isActive,
  });

  @override
  _EditAnggotaPageState createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  TextEditingController _nomorIndukController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();
  TextEditingController _noTeleponController = TextEditingController();
  bool _isActive = true;

  final myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    _nomorIndukController.text = widget.nomorInduk;
    _namaController.text = widget.nama;
    _alamatController.text = widget.alamat;
    _tglLahirController.text = widget.tglLahir;
    _noTeleponController.text = widget.noTelepon;
    _isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
        backgroundColor: Colors.pink[50],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomorIndukController,
              decoration: InputDecoration(labelText: 'Nomor Induk'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tglLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noTeleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Aktif:'),
                RadioListTile<bool>(
                  title: Text('Aktif'),
                  value: true,
                  groupValue: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value!;
                    });
                  },
                ),
                RadioListTile<bool>(
                  title: Text('Tidak Aktif'),
                  value: false,
                  groupValue: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value!;
                    });
                  },
                ),   
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _editAnggota(context, widget.id);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.pink.shade700,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.pink[50],
    );
  }

  void _editAnggota(BuildContext context, String id) async {
    try {
      final _dio = Dio();
      final _response = await _dio.put(
        '$_apiUrl/anggota/$id',
        data: {
          'nomor_induk': _nomorIndukController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
          'is_active': _isActive,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${myStorage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      print(_response.data);
      if (_response.statusCode == 200) {
        Navigator.pop(context, {
          'id': id,
          'nomor_induk': _nomorIndukController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
          'is_active': _isActive,
        });
      } else {
        _showErrorDialog(context, 'Gagal mengedit anggota.');
      }
    } on DioException catch (e) {
      _showErrorDialog(context, 'Gagal mengedit anggota.');
      if (e.response != null) {
        print('${e.response!.data} - ${e.response!.statusCode}');
      } else {
        print('Request failed with exception: $e');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
