import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class TransaksiPage extends StatelessWidget {
  final String? anggotaId;

  const TransaksiPage({Key? key, this.anggotaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: Text(
          'Tambah Transaksi',
        style: GoogleFonts.acme(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: AddTransaksi(anggotaId: anggotaId),
    );
  }
}

class AddTransaksi extends StatefulWidget {
  final String? anggotaId;

  const AddTransaksi({Key? key, this.anggotaId}) : super(key: key);

  @override
  _AddTransaksiState createState() => _AddTransaksiState();
}

class _AddTransaksiState extends State<AddTransaksi> {
  final _storage = GetStorage();
  List<Map<String, dynamic>> _jenisTransaksi = [];
  int _selectedTransactionIndex = 0;
  late TextEditingController _nominalController;
  int MULTIPLIER_DEBIT = 1;
  int MULTIPLIER_CREDIT = -1;

  double _saldoAwal = 0.0; // Simpan saldo awal di sini

  @override
  void initState() {
    super.initState();
    _nominalController = TextEditingController();
    _loadJenisTransaksi();
    _loadSaldoAwal(); // Muat saldo awal saat inisialisasi widget
  }

  Future<void> _loadJenisTransaksi() async {
    try {
      Response response = await Dio().get(
        'https://mobileapis.manpits.xyz/api/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['jenistransaksi'];
        if (data is List) {
          setState(() {
            _jenisTransaksi = List<Map<String, dynamic>>.from(data);
            if (_jenisTransaksi.isNotEmpty) {
              _selectedTransactionIndex = 0;
            }
          });
        } else {
          print('Unexpected data format: $data');
        }
      } else {
        print('Gagal memuat jenis transaksi.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _loadSaldoAwal() async {
    try {
      Response response = await Dio().get(
        'https://mobileapis.manpits.xyz/api/saldoawal/${widget.anggotaId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _saldoAwal = response.data['data']['saldo_awal'] ?? 0.0;
        });
      } else {
        print('Gagal memuat saldo awal.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16.0),

          // Dropdown untuk memilih jenis transaksi
          if (_jenisTransaksi.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<Map<String, dynamic>>(
              value: _jenisTransaksi[_selectedTransactionIndex],
              items: _jenisTransaksi.map((jenis) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: jenis,
                  child: Text(
                    jenis['trx_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTransactionIndex = _jenisTransaksi.indexOf(value!);
                });
              },
              hint: const Text('Pilih Jenis Transaksi'),
              isExpanded: true,
            ),
          TextFormField(
            controller: _nominalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nominal',
            ),
          ),
          const SizedBox(height: 16.0),

          // Tombol untuk menyimpan transaksi
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool validasiTransaksi = await showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: Text ('Konfirmasi Transaksi'),
                      content: Text(
                        'Apakah anda yakin ingin melakukan transaksi?'),
                        actions: <Widget>[
                        TextButton(
                          onPressed: () { 
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Ya'),
                        ),
                      ],
                    ),
                  );                    
                  if (validasiTransaksi == true){
                  try {
                    Response postResponse = await Dio().post(
                      'https://mobileapis.manpits.xyz/api/tabungan',
                      data: {
                        'anggota_id': widget.anggotaId,
                        'trx_id': _jenisTransaksi[_selectedTransactionIndex]
                            ['id'],
                        'trx_nominal': double.parse(_nominalController.text),
                        'trx_multiply':
                            _jenisTransaksi[_selectedTransactionIndex]
                                        ['trx_multiply'] ==
                                    MULTIPLIER_DEBIT
                                ? MULTIPLIER_DEBIT
                                : MULTIPLIER_CREDIT,
                      },
                      options: Options(
                        headers: {
                          'Authorization': 'Bearer ${_storage.read('token')}'
                        },
                      ),
                    );

                    if (postResponse.statusCode == 200) {
                      print('Transaksi berhasil ditambahkan');
                      print(
                          'Detail Transaksi Baru: ${postResponse.data['data']['tabungan']}');

                      // Simpan transaksi ke penyimpanan lokal
                      _saveTransactionLocally(
                          postResponse.data['data']['tabungan']);
                    } else {
                      print('Gagal menambahkan transaksi');
                    }
                  } catch (error) {
                    print('Error: $error');
                  }
                  Navigator.of(context).pop();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveTransactionLocally(Map<String, dynamic> transaction) {
    // Ambil data transaksi sebelumnya dari penyimpanan lokal
    List<dynamic> transactionsList = _storage.read('transactions') ?? [];
    transactionsList.add(transaction);
    _storage.write('transactions', transactionsList);
  }
}