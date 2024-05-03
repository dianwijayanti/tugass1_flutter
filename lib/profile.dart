import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progmob/home.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.lexend(),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Panggil fungsi goLogout saat tombol logout ditekan
              goLogout(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/product 4.png'),
              radius: 75.0,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.pink,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.pink,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.pink,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.pink,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                goUser(context); // Panggil fungsi goUser saat tombol Save ditekan
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.pink.shade700,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                goLogout(context); // Panggil fungsi goLogout saat tombol Log Out ditekan
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.pink.shade700,
              ),
              child: const Text(
                'Log Out',
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
    );
  }

  void goUser(BuildContext context) async {
    try {
      final _dio = Dio();
      final _response = await _dio.get(
        '$_apiUrl/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${myStorage.read('token')}'},
        ),
      );
      print(_response.data);

      // Mendapatkan data user dari response
      final userData = _response.data['data'];

      // Mendapatkan nilai dari masing-masing field
      final String name = userData['name'];
      final String username = userData['username'];
      final String email = userData['email'];
      final String phoneNumber = userData['phone_number'];

      // Menyimpan data user ke penyimpanan lokal
      myStorage.write('name', name);
      myStorage.write('username', username);
      myStorage.write('email', email);
      myStorage.write('phone_number', phoneNumber);

      // Navigasi ke halaman user profile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Ganti HomePage dengan nama home page Anda
      );
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
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
      Navigator.pushReplacementNamed(context, '/main');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
