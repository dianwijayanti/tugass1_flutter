import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:progmob/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  bool _passwordVisible = false; // Tambahkan variabel ini
  bool _isPasswordValid = true; // Tambahkan variabel untuk validasi password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register to Byeol',
          style: GoogleFonts.lexend(),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Image.asset(
                'assets/logooo.png',
                height: 250.0,
                width: 250.0,
                fit: BoxFit.contain,
              ),
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
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = value.length >= 8; // Validasi minimal 8 karakter
                  });
                },
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
              if (!_isPasswordValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Password must be at least 8 characters long',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isPasswordValid
                    ? () {
                        if (_isValidEmail(_emailController.text)) {
                          goRegister(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Email'),
                                content: Text('Please enter a valid email address.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
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
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.pink.shade700,
                ),
                child: const Text(
                  'Register',
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
    );
  }

  void goRegister(BuildContext context) async {
    try {
      final _dio = Dio();
      final _response = await _dio.post(
        '$_apiUrl/register', // Ubah endpoint ke register
        data: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      print(_response.data);
      myStorage.write('token', _response.data['data']['token']);

      // Navigasi ke halaman beranda jika registrasi berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Ganti HomePage dengan nama home page Anda
      );
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  bool _isValidEmail(String email) {
    // Validasi format email menggunakan RegExp
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }
}
