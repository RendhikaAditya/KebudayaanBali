import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({Key? key}) : super(key: key);

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  var logger = Logger();

  String? userName;
  TextEditingController searchController = TextEditingController();
  // late List<Datum> pegawaiList = [];
  // late List<Datum> filteredPegawaiList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   getPegawaiList();
  // }
  //
  // Future<void> getPegawaiList() async {
  //   try {
  //     http.Response res = await http.get(
  //         Uri.parse('${ApiUrl().baseUrl}read.php?data=pegawai'));
  //     logger.d("data di dapat :: ${modelPegawaiFromJson(res.body).data}");
  //     setState(() {
  //       pegawaiList = modelPegawaiFromJson(res.body).data ?? [];
  //       filteredPegawaiList = pegawaiList;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(e.toString())));
  //     });
  //   }
  // }

  // void filterPegawaiList(String query) {
  //   setState(() {
  //     filteredPegawaiList = pegawaiList
  //         .where((pegawai) =>
  //             pegawai.namaPegawai.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pegawai',
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
              // onChanged: filterPegawaiList,
              decoration: InputDecoration(
                labelText: 'Search Pegawai',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: filteredPegawaiList.length,
            //     itemBuilder: (context, index) {
            //       Datum data = filteredPegawaiList[index];
            //       return Padding(
            //         padding: EdgeInsets.all(8),
            //         child: GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => PageDetailPegawai(data),
            //               ),
            //             );
            //           },
            //           child: Card(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Padding(
            //                   padding: EdgeInsets.all(8),
            //                   child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(10),
            //                     // child: Image.network(
            //                     //   'http://192.30.35.126/edukasi/gambar/${data?.gambarBerita}',
            //                     //   fit: BoxFit.fill,
            //                     // ),
            //                   ),
            //                 ),
            //                 ListTile(
            //                   title: Text(
            //                     "${data.namaPegawai}",
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                   subtitle: Text(
            //                     "${data.noBp}",
            //                     maxLines: 2,
            //                     style: TextStyle(
            //                       fontSize: 10,
            //                       color: Colors.black54,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => TambahDataPegawai()),
          // );
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
