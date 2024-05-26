import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'add_anggota.dart';
import 'edit_anggota.dart';
import 'delete_anggota.dart';
import 'list_anggota.dart';

class AnggotaPage extends StatefulWidget {
  @override
  _AnggotaPageState createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  List<Map<String, dynamic>> _daftarAnggota = [];
  final _storage = GetStorage();
  final _listAllAnggota = ListAllAnggota();

  @override
  void initState() {
    super.initState();
    _loadDaftarAnggota(); // Load member data on app startup
  }

  void _addAnggota(Map<String, dynamic> newAnggota) {
  setState(() {
    _daftarAnggota.add(newAnggota);
    _saveDaftarAnggota();
  });
}

  void _loadDaftarAnggota() {
    final savedDaftarAnggota = _storage.read<List>('daftarAnggota');
    if (savedDaftarAnggota != null) {
      setState(() {
        _daftarAnggota = savedDaftarAnggota.cast<Map<String, dynamic>>();
      });
    }
  }

  void _printAllAnggota() async {
  // Mendapatkan dan mencetak daftar semua anggota
  List<Map<String, dynamic>> allAnggota = await _listAllAnggota.getAllAnggota();
  if (allAnggota.isNotEmpty) {
    print("Daftar semua anggota:");
    for (var anggota in allAnggota) {
      print("ID: ${anggota['id']}, "
            "Nomor Induk: ${anggota['nomor_induk']}, "
            "Nama: ${anggota['nama']}, "
            "Alamat: ${anggota['alamat']}, "
            "Tgl Lahir: ${anggota['tgl_lahir']}, "
            "Telepon: ${anggota['telepon']}, "
            "Status Aktif: ${anggota['is_active']}");
    }
  } else {
    print("Gagal mendapatkan daftar semua anggota atau daftar kosong.");
  }
}

  void _saveDaftarAnggota() {
    _storage.write('daftarAnggota', _daftarAnggota);
  }

  Future<void> _deleteAnggota(String id, int index) async {
    final deleteService = DeleteAnggotaPage();
    final success = await deleteService.deleteAnggotaById(id);

    if (success) {
      setState(() {
        _daftarAnggota.removeAt(index);
        _saveDaftarAnggota();
      });
      _showSnackBar('Anggota berhasil dihapus', Colors.green);
    } else {
      _showSnackBar('Gagal menghapus anggota', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
    print(message); // This will print the message to the debug console
  }

  void _showAnggotaDetails(String id) async {
  try {
     Map<String, dynamic>? anggotaDetails = _daftarAnggota.firstWhere(
      (anggota) => anggota['id'] == id,
      orElse: () => <String, dynamic>{},
    );

      if (anggotaDetails.isNotEmpty) {
        print('Detail anggota:');
        print("ID: ${anggotaDetails['id']}, "
              "Nomor Induk: ${anggotaDetails['nomor_induk']}, "
              "Nama: ${anggotaDetails['nama']}, "
              "Alamat: ${anggotaDetails['alamat']}, "
              "Tgl Lahir: ${anggotaDetails['tgl_lahir']}, "
              "Telepon: ${anggotaDetails['telepon']}, "
              "Image URL: ${anggotaDetails['image_url']}, "
              "Status Aktif: ${anggotaDetails['status_aktif']}");
      } else {
        print('Anggota tidak ditemukan.');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil detail anggota: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _printAllAnggota,
          child: Text(
            'Daftar Anggota',
            style: GoogleFonts.lexend(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _daftarAnggota.length,
        itemBuilder: (context, index) {
          final anggota = _daftarAnggota[index];
          return ListTile(
            title: GestureDetector(
              onTap: () {
                _showAnggotaDetails(anggota['id']);
              },
              child: Text(
                anggota['nama'] ?? '',
                style: GoogleFonts.cabin(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAnggotaPage(
                          id: anggota['id'],
                          nomorInduk: anggota['nomor_induk'],
                          nama: anggota['nama'],
                          alamat: anggota['alamat'],
                          tglLahir: anggota['tgl_lahir'],
                          noTelepon: anggota['telepon'],
                          isActive: anggota['is_active'],
                        ),
                      ),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _daftarAnggota[index] = result;
                        _saveDaftarAnggota();
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    _deleteAnggota(anggota['id'], index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAnggota = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAnggotaPage()),
          );

          if (newAnggota != null) {
            setState(() {
              _daftarAnggota.add(newAnggota);
              _saveDaftarAnggota();
            });
          }
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
    );
  }
}
