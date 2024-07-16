import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterai/pages/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _searchField(),
          _responseField(),
          const SizedBox(height: 40),
          _toCryptoButton(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Flutter AI',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        menuButton(),
      ],
    );
  }

  GestureDetector menuButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 37,
        decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10)),
        child: SvgPicture.asset(
          'assets/icons/Dots.svg',
          height: 20,
          width: 20,
        ),
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0)
      ]),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Ask Flutter AI',
            hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
            suffixIcon: IconButton(
              icon: SvgPicture.asset('assets/icons/Search.svg'),
              onPressed: () {
                _askAI(_textController.text);
              },
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Container _responseField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0)
      ]),
      width: double.infinity,
      height: 500,
      child: TextField(
        controller: _responseController,
        enabled: false,
        expands: true,
        minLines: null,
        maxLines: null,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            // hintText: 'Response appears here',
            // hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Future<void> _askAI(String prompt) async {
    final apiKey = dotenv.env['API_KEY'];
    // final apiKey = '';
    // const uri = 'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions';
    const uri = 'https://api.openai.com/v1/chat/completions';
    final url = Uri.parse(uri);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt},
        ]
        // 'prompt': prompt,
        // 'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _responseController.text = data['choices'][0]['message']['content'];
      });
    } else {
      setState(() {
        _responseController.text = 'Failed to get response: ${response.body}';
      });
    }
  }

  ElevatedButton _toCryptoButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Crypto()),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: const Text('Go to Crypto Page'),
    );
  }
}
