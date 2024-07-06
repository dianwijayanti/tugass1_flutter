import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progmob/add_anggota.dart';
import 'package:progmob/details_transaksi.dart';
import 'package:progmob/edit_anggota.dart';
import 'package:progmob/insert_transaksi.dart';
import 'package:progmob/delete_anggota.dart';

class AnggotaPage extends StatefulWidget {
  @override
  _AnggotaPageState createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  List<Map<String, dynamic>> _anggotaList = [];
  final Dio _dio = Dio();
  final GetStorage _myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnggotaList();
  }

  void _addAnggota(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAnggotaPage()),
    );
    if (result != null) {
      _fetchAnggotaList(); // Refresh the list after adding
    }
  }

  void _editAnggota(BuildContext context, Map<String, dynamic> anggota) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAnggotaPage(
          id: anggota['id'].toString(),
          nomorInduk: anggota['nomor_induk'].toString(),
          nama: anggota['nama'].toString(),
          alamat: anggota['alamat'].toString(),
          tglLahir: anggota['tgl_lahir'].toString(),
          noTelepon: anggota['telepon'].toString(),
          isActive: anggota['status_aktif'],
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      _fetchAnggotaList(); // Refresh the list after editing
    }
  }

  void _deleteAnggota(int id) async {
    DeleteAnggotaPage deleteAnggotaPage = DeleteAnggotaPage();
    bool success = await deleteAnggotaPage.deleteAnggotaById(id.toString());
    if (success) {
      setState(() {
        _anggotaList.removeWhere((item) => item['id'] == id);
      });
    } else {
      print('Failed to delete anggota');
    }
  }

  void _fetchAnggotaList() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_myStorage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          final anggotas = data['anggotas'];
          if (anggotas is List) {
            setState(() {
              _anggotaList = List<Map<String, dynamic>>.from(anggotas);
              _isLoading = false;
            });
          } else {
            print('Response data format is incorrect: $anggotas');
            _isLoading = false;
          }
        } else {
          print('Data is null in response: $data');
          _isLoading = false;
        }
      } else {
        print('Failed to load anggota list');
        _isLoading = false;
      }
    } catch (error) {
      print('Error: $error');
      _isLoading = false;
    }
  }

  void _showAnggotaDetailDialog(Map<String, dynamic> anggota) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Detail Anggota',
                    style: GoogleFonts.cabin(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(anggota['nama'].toString()),
                  subtitle: Text('Nama'),
                ),
                ListTile(
                  leading: Icon(Icons.badge),
                  title: Text(anggota['nomor_induk'].toString()),
                  subtitle: Text('Nomor Induk'),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(anggota['alamat'].toString()),
                  subtitle: Text('Alamat'),
                ),
                ListTile(
                  leading: Icon(Icons.cake),
                  title: Text(anggota['tgl_lahir'].toString()),
                  subtitle: Text('Tanggal Lahir'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(anggota['telepon'].toString()),
                  subtitle: Text('Nomor Telepon'),
                ),
                ListTile(
                  leading: Icon(
                    anggota['status_aktif'].toString() == '1'
                        ? Icons.check_circle
                        : Icons.cancel,
                  ),
                  title: Text(
                    anggota['status_aktif'].toString() == '1'
                        ? 'Active'
                        : 'Inactive',
                  ),
                  subtitle: Text('Status'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnggotaCard(Map<String, dynamic> anggota) {
    return Card(
      child: ListTile(
        title: Text(anggota['nama']),
        subtitle: Text('Nomor Induk: ${anggota['nomor_induk']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                _showAnggotaDetailDialog(anggota);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAnggotaPage(
                      id: anggota['id'].toString(),
                      nomorInduk: anggota['nomor_induk'].toString(),
                      nama: anggota['nama'].toString(),
                      alamat: anggota['alamat'].toString(),
                      tglLahir: anggota['tgl_lahir'].toString(),
                      noTelepon: anggota['telepon'].toString(),
                      isActive: anggota['is_active'],
                    ),
                  ),
                );
                if (result != null) {
                  _fetchAnggotaList(); // Refresh the list after editing
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfirmasi"),
                      content: Text(
                          "Apakah Anda yakin ingin menghapus anggota ini?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Batal"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Hapus"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteAnggota(anggota['id']);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.attach_money),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransaksiPage(anggotaId: anggota['id'].toString()),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.monetization_on),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionDetailPage(anggota: anggota),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Anggota',
                    style: GoogleFonts.rowdies(
                    textStyle: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _anggotaList.length,
                    itemBuilder: (context, index) {
                      return _buildAnggotaCard(_anggotaList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAnggota(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}