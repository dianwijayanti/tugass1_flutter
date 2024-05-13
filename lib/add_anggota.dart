import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class AddAnggotaPage extends StatefulWidget {
  @override
  _AddAnggotaPageState createState() => _AddAnggotaPageState();
}

class _AddAnggotaPageState extends State<AddAnggotaPage> {
  TextEditingController _nomorIndukController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();
  TextEditingController _noTeleponController = TextEditingController();

  final myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anggota'),
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tglLahirController,
              decoration: InputDecoration(labelText: 'Born Date'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noTeleponController,
              decoration: InputDecoration(labelText: 'Telephone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addAnggota(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
               ), // Warna tombol pink tua
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
        ]
      ),
    ),
      backgroundColor: Colors.pink[50],
    );
  }

  void _addAnggota(BuildContext context) async {
  try {
    final _dio = Dio();
    final _response = await _dio.post(
      '$_apiUrl/anggota', 
      data: {
        'nomor_induk': _nomorIndukController.text,
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'tgl_lahir': _tglLahirController.text,
        'telepon': _noTeleponController.text, 
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
      // Member added successfully, handle logic here (e.g., show success message)
      Navigator.pop(context); // Close current page (optional)
    } else {
      // Handle error adding member
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menambahkan anggota.'),
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
  } on DioException catch (e) {
    print('${e.response} - ${e.response?.statusCode}');
    // Handle specific DioExceptions here if needed
  }
}
}