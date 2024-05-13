import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progmob/anggota.dart';
import 'package:progmob/profile.dart';
import 'product.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ProductPage(), 
    Text('Cart Page'),
    AnggotaPage(),
    ProfilePage(),
  ];

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
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Menampilkan label di bawah ikon selalu
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Anggota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'My Profile',
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