import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<Map<String, dynamic>> getMarketData(String coinId) async {
    final url = Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&ids=$coinId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0];
      } else {
        throw Exception('Coin not found');
      }
    } else {
      throw Exception('Failed to load market data');
    }
  }
}
