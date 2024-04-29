import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../model/model_budaya.dart';
import '../utils/api_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var logger = Logger();

  String? userName;
  late TextEditingController _searchController;
  late Future<List<Datum>?> _futureBudaya;
  List<Datum>? _searchResult;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureBudaya = getBudaya();
    _searchController.addListener(() {
      searchBudaya(_searchController.text);
    });
  }

  Future<List<Datum>?> getBudaya() async {
    try {
      http.Response res = await http
          .get(Uri.parse('${ApiUrl().baseUrl}read.php?data=budaya'));
      logger.d("Data diperoleh :: ${modelBudayaFromJson(res.body).data}");
      return modelBudayaFromJson(res.body).data;
    } catch (e) {
      logger.e("Terjadi kesalahan: $e");
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      });
      return null; // Kembalikan null jika terjadi kesalahan
    }
  }

  Future<void> searchBudaya(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResult = null;
      });
      return;
    }
    List<Datum>? berita = await getBudaya();
    if (berita != null) {
      List<Datum> result = berita
          .where((datum) =>
              datum.namaKebudayaan!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _searchResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kebudayaan Bali',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kebudayaan...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchBudaya('');
                        },
                      )
                    : null,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureBudaya,
                builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                  logger.d("Hash data :: ${snapshot.hasData}");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    final data = _searchResult ?? snapshot.data;
                    if (data == null || data.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada data ditemukan."),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Datum? dataItem = data[index];
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                // Handle onTap action
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          '${ApiUrl().baseUrl}gambar/${dataItem?.foto}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "${dataItem?.namaKebudayaan}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${dataItem?.deskripsi}",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
