import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progmob/anggota.dart';
import 'package:progmob/profile.dart';
import 'package:progmob/setting_bunga.dart';
import 'front.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final myStorage = GetStorage();
  late String anggotaId;

  @override
  void initState() {
    super.initState();
    anggotaId = myStorage.read('anggotaId') ?? '';
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      FrontPage(),
      SettingBungaPage(),
      AnggotaPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Menangani ketika tombol kembali di tekan
      onWillPop: () async => false, // Mencegah pengguna menekan tombol kembali
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'BYEOL',
            style: GoogleFonts.lilitaOne(
              fontWeight: FontWeight.w300,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.pink[50],
          centerTitle: true,
          automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        ),
        body: Center(
          child: _widgetOptions().elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType
              .fixed, // Menampilkan label di bawah ikon selalu
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Bunga',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Anggota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.pink[50],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
