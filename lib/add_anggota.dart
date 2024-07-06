import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:progmob/helper.dart'; // For date formatting

class AddAnggotaPage extends StatefulWidget {
  final bool isActiveFromEdit;

  AddAnggotaPage({this.isActiveFromEdit = true});

  @override
  _AddAnggotaPageState createState() => _AddAnggotaPageState();
}

class _AddAnggotaPageState extends State<AddAnggotaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorIndukController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  bool _isActive = true; // Default active status
  DateTime? _tglLahir;

  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActiveFromEdit;
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _tglLahir ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _tglLahir = pickedDate;
        _tglLahirController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _addAnggota(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      _dio.interceptors.clear();
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] =
                'Bearer ${_storage.read('token')}';
            return handler.next(options);
          },
          onError: (DioError e, handler) async {
            if (e.response?.statusCode == 406) {
              String newAccessToken = await Helper.loginForRefreshToken();
              e.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              return handler.resolve(await _dio.fetch(e.requestOptions));
            }
            return handler.next(e);
          },
        ),
      );

      final response = await _dio.post(
        '$_apiUrl/anggota',
        data: {
          'nomor_induk': _nomorIndukController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
          'status_aktif': _isActive ? '1' : '0',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_storage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      final responseData = response.data;
      if (response.statusCode == 200 && responseData['success']) {
        final anggota = responseData['data']['anggota'];
        final newAnggota = {
          'id': anggota['id'].toString(),
          'nomor_induk': anggota['nomor_induk'] ?? '',
          'nama': anggota['nama'] ?? '',
          'alamat': anggota['alamat'] ?? '',
          'tgl_lahir': anggota['tgl_lahir'] ?? '',
          'telepon': anggota['telepon'] ?? '',
          'is_active': anggota['status_aktif'] ?? true,
        };

        _storage.write('anggotaId', newAnggota['id']);

         // Simpan anggota ke storage
        List<dynamic> anggotaList = _storage.read('anggota') ?? [];
        anggotaList.add(newAnggota);
        _storage.write('anggota', anggotaList);

        // Tampilkan dialog sukses
        Navigator.pop(context, {'success': true}); // Return result
      } else {
        String errorMessage =
            responseData['message'] ?? 'Gagal menambahkan anggota.';
        _showErrorDialog(context, errorMessage);
      }
    } on DioError catch (e) {
      String errorMessage = 'Gagal menambahkan anggota.';
      if (e.response != null) {
        errorMessage = 'Gagal menambahkan anggota. ${e.response!.data}';
        print('${e.response!.data} - ${e.response!.statusCode}');
      } else {
        errorMessage = 'Request failed with exception: $e';
        print('Request failed with exception: $e');
      }
      _showErrorDialog(context, errorMessage);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: Text(
          'Tambah Anggota',
            style: GoogleFonts.acme(
              textStyle: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
          key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomorIndukController,
                  decoration: InputDecoration(labelText: 'Nomor Induk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Induk tidak boleh kosong';
                    }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _tglLahirController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'Masukkan tanggal lahir',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal Lahir tidak boleh kosong';
                    }
                      return null;
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _noTeleponController,
                  decoration: InputDecoration(labelText: 'Nomor Telepon'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon tidak boleh kosong';
                    }
                      return null;
                    },
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Status Aktif:'),
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                         _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                  _addAnggota(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.pink.shade700,
                ),
                child: Text(
                  'Simpan',
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
      ),
      backgroundColor: Colors.white,
    );
  }
}