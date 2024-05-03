import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:progmob/product.dart';
import 'home.dart';
import 'login.dart'; 
import 'register.dart'; 
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

void main() async {
  await GetStorage.init();
  runApp(LoginApp());
}

final dio = Dio();
final myStorage = GetStorage();
final apiUrl = 'https://mobileapis.manpits.xyz/api';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BYEOL',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LoginRegisterPage(),
       routes: {
        '/login': (context) => LoginPage(),
        '/register' : (context) => RegisterPage(),
        '/home' :(context) => HomePage(),
        '/main' :(context) => LoginRegisterPage(),
        '/product' :(context) => ProductPage()

       }
    );
  }
}

class LoginRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink[30],
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: size.height * 0.55,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.pink[50],
              ),
              child: Image.asset(
                'assets/logo.png',
                width: 100,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.5,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Hi Bestie!\n Welcome to BYEOL",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lilitaOne(
                      fontWeight: FontWeight.w300,
                      fontSize: 30,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Explore your own Style\nand Become a BYEOL with us",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(
                double.infinity,
                50,
                ),
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
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(
                double.infinity,
                50,
              ),
              backgroundColor: Colors.pink[200], 
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
    );
  }
}