import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P3K',
      home: const MainPage(),
      theme: ThemeData(primarySwatch: Colors.amber),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List _pertolonganPertama = [];
  List _filtered = [];
  bool _isInput = true;
  String userInput = '';
  late TextEditingController _searchController;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('content/pertolongan_pertama.json');
    final data = await json.decode(response);
    setState(() {
      _pertolonganPertama = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Aplikasi P3K'),
        ),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 240,
                      child: TextField(
                        onChanged: (value) => setState(() {
                          userInput = value;
                          _filtered = _pertolonganPertama
                              .where((element) => (element["judul"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(userInput.toLowerCase())))
                              .toList();
                        }),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Pertolongan Pertama',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isInput = !_isInput;
                          });
                        },
                        icon: Icon(Icons.search)),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(_filtered.length, (index) {
                    return Card(
                      child: Column(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            _filtered[index]["gambar"],
                            width: 180,
                            height: 90,
                          ),
                          Text(
                            _filtered[index]["judul"],
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
