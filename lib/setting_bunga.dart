import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class SettingBungaPage extends StatefulWidget {
  @override
  _SettingBungaPageState createState() => _SettingBungaPageState();
}

class _SettingBungaPageState extends State<SettingBungaPage>
    with SingleTickerProviderStateMixin {
  final Dio _dio = Dio();
  final GetStorage _myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final TextEditingController _persenController = TextEditingController();
  bool _isLoading = true;
  String _activeBunga = '';
  List<String> _inactiveBungaHistory = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  void _printDebugInfo() {
    print("Active Bunga: $_activeBunga");
    print("Inactive Bunga History: $_inactiveBungaHistory");
    print("Stored Token: ${_myStorage.read('token')}");
  }

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _printDebugInfo();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation =
        Tween<double>(begin: 0, end: double.tryParse(_activeBunga) ?? 0)
            .animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadLocalData() async {
    try {
      if (_myStorage.hasData('activeBunga') &&
          _myStorage.hasData('inactiveBungaHistory')) {
        setState(() {
          _activeBunga = _myStorage.read('activeBunga');
          _inactiveBungaHistory =
              List<String>.from(_myStorage.read('inactiveBungaHistory'));
          _isLoading = false;
        });
      } else {
        await _fetchBungaSettings();
      }
    } catch (e) {
      print("Error loading local data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchBungaSettings() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_myStorage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _activeBunga = data['active']?['persen'] ?? '0';
          _inactiveBungaHistory = List<String>.from(
              data['history']?.map((item) => item['persen']) ?? []);
        });

        _myStorage.write('activeBunga', _activeBunga);
        _myStorage.write('inactiveBungaHistory', _inactiveBungaHistory);
      } else {
        print('Failed to fetch bunga settings');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addSettingBunga(String persen) async {
    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_myStorage.read('token')}'},
        ),
        data: {
          'persen': persen,
          'isaktif': '1',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _inactiveBungaHistory.insert(0, _activeBunga);
          _activeBunga = persen;

          _myStorage.write('activeBunga', _activeBunga);
          _myStorage.write('inactiveBungaHistory', _inactiveBungaHistory);

          // Clear text field after adding
          _persenController.clear();

          // Reset animation with new value
          _controller.reset();
          _animation = Tween<double>(begin: 0, end: double.parse(_activeBunga))
              .animate(_controller);
          _controller.forward();
        });
        print('Interest setting added successfully');
      } else {
        print('Failed to add interest setting');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Bunga Aktif',
                    style: GoogleFonts.acme(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                _activeBunga == '0' || _activeBunga.isEmpty
                    ? SizedBox.shrink() // Hide if activeBunga is 0 or empty
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${_animation.value.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Aktif',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 16),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _persenController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Persen Bunga',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () {
                            if (_persenController.text.isNotEmpty) {
                              _addSettingBunga(_persenController.text);
                            }
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Ubah Bunga'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'History Bunga',
                    style: GoogleFonts.acme(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: _inactiveBungaHistory
                            .where((bunga) => bunga != '0' && bunga.isNotEmpty)
                            .map((bunga) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$bunga%',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Tidak Aktif',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
