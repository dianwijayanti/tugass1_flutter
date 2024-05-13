import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_anggota.dart';

class AnggotaPage extends StatefulWidget {
  @override
  _AnggotaPageState createState() => _AnggotaPageState();
}

class _AnggotaPageState extends State<AnggotaPage> {
  List<String> _daftarAnggota = ['Anggota 1', 'Anggota 2']; // List untuk menyimpan daftar anggota

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Anggota',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold, 
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: _daftarAnggota.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _daftarAnggota[index],
              style: GoogleFonts.cabin(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Tambahkan logika untuk menangani ketika anggota dipilih
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    // Tambahkan logika untuk mengedit anggota
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    // Tambahkan logika untuk menghapus anggota
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah anggota
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAnggotaPage()),
          ).then((newAnggotaName) {
            // Callback untuk menangani data anggota yang baru ditambahkan
            if (newAnggotaName != null) {
              setState(() {
                _daftarAnggota.add(newAnggotaName); // Tambahkan anggota baru ke daftar
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnggotaPage(),
  ));
}
