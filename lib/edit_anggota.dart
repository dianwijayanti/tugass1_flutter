import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

class EditAnggotaPage extends StatefulWidget {
  final String id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelepon;
  final int? isActive; // Ubah tipe data isActive menjadi nullable integer

  EditAnggotaPage({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tglLahir,
    required this.noTelepon,
    this.isActive, // Tambahkan tanda tanya (?) untuk nullable
  });

  @override
  _EditAnggotaPageState createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  final TextEditingController _nomorIndukController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  late bool _isActive; // Tipe data boolean untuk status isActive
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final GetStorage _myStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Menginisialisasi nilai controller dengan nilai awal dari widget
    _nomorIndukController.text = widget.nomorInduk;
    _namaController.text = widget.nama;
    _alamatController.text = widget.alamat;
    _tglLahirController.text = widget.tglLahir;
    _noTeleponController.text = widget.noTelepon;
    _isActive = (widget.isActive ?? 0) ==
        1; // Mengambil nilai isActive dari widget dan handling nullable dengan 0 dan 1
  }

  // Fungsi untuk menampilkan dialog pemilihan tanggal
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.tglLahir) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _tglLahirController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: Text(
          'Edit Anggota',
        style: GoogleFonts.acme(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nomorIndukController,
              decoration: InputDecoration(labelText: 'Nomor Induk'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _tglLahirController,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _noTeleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 20.0),
            SwitchListTile(
              title: Text('Aktif'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive =
                      value; // Mengubah nilai _isActive saat switch digeser
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _editAnggota(context,widget.id); // Memanggil fungsi _editAnggota saat tombol Simpan ditekan
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Fungsi untuk mengirim data yang telah diedit ke backend
  void _editAnggota(BuildContext context, String id) async {
    try {
      final Dio _dio = Dio();
      final response = await _dio.put(
        '$_apiUrl/anggota/$id',
        data: {
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
          'status_aktif':
              _isActive ? 1 : 0, // Mengubah nilai boolean ke 0 atau 1
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_myStorage.read('token')}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Menambahkan debug console disini
        print('Anggota berhasil diedit: ${response.data}');
        Navigator.pop(context, {
          'id': id,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'telepon': _noTeleponController.text,
          'status_aktif': _isActive
              ? 1
              : 2, // Mengirim kembali nilai _isActive yang telah diubah ke 0 atau 1
        });
      } else {
        _showErrorDialog(context, 'Gagal mengedit anggota.');
      }
    } on DioError catch (e) {
      _showErrorDialog(context, 'Gagal mengedit anggota.');
      print('Request failed with exception: $e');
    }
  }

  // Fungsi untuk menampilkan dialog error
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