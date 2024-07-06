import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage for shared preferences

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nomorIndukController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();
  TextEditingController _teleponController = TextEditingController();
  final myStorage =
      GetStorage(); // Instance of GetStorage for shared preferences

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    String prefix = getPrefixFromToken(myStorage.read('token'));
    _nomorIndukController.text = myStorage.read('${prefix}_nomor_induk') ?? '';
    _nameController.text = myStorage.read('${prefix}_name') ?? '';
    _alamatController.text = myStorage.read('${prefix}_alamat') ?? '';
    _tglLahirController.text = myStorage.read('${prefix}_tgl_lahir') ?? '';
    _teleponController.text = myStorage.read('${prefix}_telepon') ?? '';
  }

  String getPrefixFromToken(String token) {
    // Assuming the prefix ID is the first part of the token before a period
    return token.split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'),
                radius: 75.0,
              ),
              SizedBox(height: 20.0),
              _buildTextField('Nomor Induk', _nomorIndukController),
              SizedBox(height: 10),
              _buildTextField('Nama', _nameController),
              SizedBox(height: 10),
              _buildTextField('Alamat', _alamatController),
              SizedBox(height: 10),
              _buildTextField('Tanggal Lahir', _tglLahirController),
              SizedBox(height: 10),
              _buildTextField('Telepon', _teleponController),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isEditing ? _saveUserProfile : _enableEditing,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.pink.shade700,
                ),
                child: Text(
                  _isEditing ? 'Simpan Perubahan' : 'Edit',
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
      enabled: _isEditing,
    );
  }

  void _enableEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveUserProfile() {
    String prefix = getPrefixFromToken(myStorage.read('token'));
    // Save user profile data to SharedPreferences
    myStorage.write('${prefix}_nomor_induk', _nomorIndukController.text);
    myStorage.write('${prefix}_name', _nameController.text);
    myStorage.write('${prefix}_alamat', _alamatController.text);
    myStorage.write('${prefix}_tgl_lahir', _tglLahirController.text);
    myStorage.write('${prefix}_telepon', _teleponController.text);

    setState(() {
      _isEditing = false;
    });
  }
}
