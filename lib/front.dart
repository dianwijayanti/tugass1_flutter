import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'add_anggota.dart';
import 'setting_bunga.dart';

class FrontPage extends StatelessWidget {
  final myStorage = GetStorage(); // Instance of GetStorage for shared preferences
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides back button
        title: Text(
          'Hello!',
          style: GoogleFonts.outfit(
            textStyle: TextStyle(fontSize: 30.0),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(context); // Call confirmation dialog on logout button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  buildCard(
                    context,
                    icon: Icons.group,
                    text: 'Anggota',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAnggotaPage()),
                      );
                    },
                  ),
                  buildCard(
                    context,
                    icon: Icons.settings,
                    text: 'Bunga',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingBungaPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                goLogout(context); // Call logout function
              },
            ),
          ],
        );
      },
    );
  }

  void goLogout(BuildContext context) async {
    try {
      final _dio = Dio();
      final _response = await _dio.get(
        '$_apiUrl/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      print(_response.data);
      Navigator.pushReplacementNamed(context, '/main'); // Redirect to main page
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  Widget buildCard(BuildContext context, {required IconData icon, required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64.0, color: Colors.pink),
              SizedBox(height: 16.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
