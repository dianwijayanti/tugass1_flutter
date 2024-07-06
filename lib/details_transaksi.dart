import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> anggota;

  const TransactionDetailPage({Key? key, required this.anggota})
      : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  List<Map<String, dynamic>> _transactions = [];
  final Dio _dio = Dio();
  final GetStorage _myStorage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  bool _isLoading = true;
  double _saldo = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTransactions(widget.anggota['id'].toString());
  }

  Future<void> _fetchTransactions(String anggotaId) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_myStorage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _transactions = response.data['data']['tabungan'] != null
              ? List<Map<String, dynamic>>.from(
                  response.data['data']['tabungan'])
              : [];
          _isLoading = false;
          _calculateSaldo();
        });
      } else {
        print('Failed to load transactions');
        _isLoading = false;
      }
    } catch (error) {
      print('Error: $error');
      _isLoading = false;
    }
  }

  void _calculateSaldo() {
    double saldo = 0.0;
    for (var transaction in _transactions) {
      int trxId = transaction['trx_id'] ?? 0;
      double trxNominal = transaction['trx_nominal'] ?? 0.0;
      if (trxId == 1 || trxId == 2 || trxId == 4 || trxId == 5) {
        saldo += trxNominal;
      } else {
        saldo -= trxNominal;
      }
    }
    setState(() {
      _saldo = saldo;
    });
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return Center(child: Text('Tidak ada transaksi untuk anggota ini'));
    }

    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              final int trxId = transaction['trx_id'] ?? 0;
              final int multiplier = transaction['trx_multiply'] ?? 0;
              final bool isCredit = multiplier == 1;

              String transactionType = '';
              switch (trxId) {
                case 1:
                  transactionType = 'Saldo Awal';
                  break;
                case 2:
                  transactionType = 'Simpanan';
                  break;
                case 3:
                  transactionType = 'Penarikan';
                  break;
                case 4:
                  transactionType = 'Bunga Simpanan';
                  break;
                case 5:
                  transactionType = 'Koreksi Penambahan';
                  break;
                case 6:
                  transactionType = 'Koreksi Pengurangan';
                  break;
                default:
                  transactionType = 'Jenis Transaksi Lainnya';
              }

              Color textColor;
              String amountSign;
              if (transactionType == 'Saldo Awal' ||
                  transactionType == 'Simpanan' ||
                  transactionType == 'Bunga Simpanan' ||
                  transactionType == 'Koreksi Penambahan') {
                textColor = Colors.green;
                amountSign = '+';
              } else {
                textColor = Colors.red;
                amountSign = '-';
              }

              String formattedAmount =
                  currencyFormat.format(transaction['trx_nominal']);
              String transactionDate = transaction['trx_tanggal'] ?? '';
              String formattedDate = transactionDate.isNotEmpty
                  ? DateFormat(' dd MMM yyyy HH:MM')
                      .format(DateTime.parse(transactionDate))
                  : '';

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    transactionType,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$amountSign$formattedAmount',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Aligns the date text to the end
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Saldo: ${currencyFormat.format(_saldo)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: Text(
          'Detail Transaksi ${widget.anggota['nama']}',
          style: GoogleFonts.acme(color: Colors.black), // Change text color if needed
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTransactionsList(),
            ),
    );
  }
}
