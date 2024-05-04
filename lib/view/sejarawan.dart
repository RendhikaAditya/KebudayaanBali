import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kebudayaan_bali/view/add_sejarawan.dart';
import 'package:kebudayaan_bali/view/detail_sejarawan.dart';
import 'package:logger/logger.dart';

import '../model/model_sejarawan.dart';
import '../utils/api_url.dart';

class SejarawanPage extends StatefulWidget {

  const SejarawanPage({Key? key}) : super(key: key);

  @override
  State<SejarawanPage> createState() => _SejarawanPageState();
}

class _SejarawanPageState extends State<SejarawanPage> {
  var logger = Logger();

  String? userName;
  TextEditingController searchController = TextEditingController();
  late List<Datum> sejarawanList = [];
  late List<Datum> filteredSejarawanList = [];

  @override
  void initState() {
    super.initState();
    getSejarawanList();
  }

  Future<void> getSejarawanList() async {
    try {
      http.Response res = await http
          .get(Uri.parse('${ApiUrl().baseUrl}read.php?data=sejarawan'));
      logger.d("data di dapat :: ${modelSejarawanFromJson(res.body).data}");
      setState(() {
        sejarawanList = modelSejarawanFromJson(res.body).data ?? [];
        filteredSejarawanList = sejarawanList;
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  void filterSejarawanList(String query) {
    setState(() {
      filteredSejarawanList = sejarawanList
          .where((sejarawan) => sejarawan.namaSejarawan!
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sejarawan',
          style: TextStyle(
            color: Colors.white,
          ), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterSejarawanList,
              decoration: InputDecoration(
                labelText: 'Search Sejarawan',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSejarawanList.length,
                itemBuilder: (context, index) {
                  Datum data = filteredSejarawanList[index];
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSejarawanPage(data),
                          ),
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Image.network(
                                '${ApiUrl().baseUrl}${data?.fotoSejarawan}',
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.namaSejarawan}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${data.asal}",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                ),
                              ]
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSejarawan(null)),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white, // Mengatur warna ikon menjadi putih
        ),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}
