import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:progmob/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  bool _passwordVisible = false; // Tambahkan variabel ini

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login to Byeol',
          style: GoogleFonts.lexend(),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                Image.asset(
                  'assets/logooo.png',
                  height: size.height * 0.3,
                  width: size.width * 0.6,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.0),
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
                  controller: _passwordController,
                  obscureText: !_passwordVisible, // Perbarui ini
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.pink, 
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    goLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.pink.shade700,
                  ),
                  child: const Text(
                    'Log In',
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
      ),
    );
  }

  void goLogin(BuildContext context) async {
    try {
      final _dio = Dio();
      final _response = await _dio.post(
        '${_apiUrl}/login',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      print(_response.data);

      if (_response.data['data'] != null && _response.data['data']['token'] != null) {
        myStorage.write('token', _response.data['data']['token']);
        // Tampilkan dialog sukses jika login berhasil
        showSuccessDialog(context, "Login Berhasil", "Anda berhasil masuk.");
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showErrorDialog(context, "Login Gagal", "Email atau Password yang dimasukkan salah.");
    } catch (e) {
      print('Error: $e');
      showErrorDialog(context, "Login Gagal", "Terjadi kesalahan, silakan coba lagi.");
    }
  }

  void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigasi ke halaman beranda setelah menutup dialog sukses
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Ganti HomePage dengan nama home page Anda
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
