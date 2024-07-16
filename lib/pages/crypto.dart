import 'package:flutter/material.dart';
import '../services/crypto_service.dart';

class Crypto extends StatefulWidget {
  const Crypto({super.key});

  @override
  State<StatefulWidget> createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {
  final TextEditingController _cryptoController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  final CryptoService _cryptoService = CryptoService();

  Future<void> _getMarketData() async {
    try {
      final coinId = _cryptoController.text;
      final data = await _cryptoService.getMarketData(coinId);

      setState(() {
        _responseController.text =
            'Name: ${data['name']}\nSymbol: ${data['symbol']}\nCurrent Price: \$${data['current_price']}\nMarket Cap: \$${data['market_cap']}';
      });
    } catch (error) {
      setState(() {
        _responseController.text = 'Failed to load market data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocurrency Market Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _cryptoField(),
            const SizedBox(height: 20),
            _responseField(),
          ],
        ),
      ),
    );
  }

  Widget _cryptoField() {
    return Column(
      children: [
        TextField(
          controller: _cryptoController,
          decoration: InputDecoration(
            labelText: 'Cryptocurrency ID (e.g., bitcoin)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _getMarketData,
          child: const Text('Get Market Data'),
        ),
      ],
    );
  }

  Widget _responseField() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ]),
      width: double.infinity,
      height: 200,
      child: TextField(
        controller: _responseController,
        enabled: false,
        expands: true,
        minLines: null,
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
