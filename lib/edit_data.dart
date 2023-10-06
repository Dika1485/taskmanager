import 'dart:convert';
import 'dart:io';
import 'package:taskmanager/list_data.dart';
import 'package:taskmanager/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final int id;
  final String nama, jurusan;
  const EditData(
      {Key? key, required this.id, required this.nama, required this.jurusan})
      : super(key: key);
  @override
  _EditDataState createState() => _EditDataState(id, nama, jurusan);
}

class _EditDataState extends State<EditData> {
  int? id;
  String? nama, jurusan;
  _EditDataState(int id, String nama, String jurusan) {
    this.id = id;
    this.nama = nama;
    this.jurusan = jurusan;
    namaController.text = nama;
    jurusanController.text = jurusan;
  }
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();
  Future putData(int? id, String nama, String jurusan) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'http://192.168.1.28/taskmanager/index.php'
        : 'http://localhost/taskmanager/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"id":"$id","nama": "$nama", "jurusan": "$jurusan"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to edit data');
    }
  }

  _buatInput(control, String hint) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? "Please enter some text"
            : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Data Mahasiswa'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(namaController, 'Masukkan Nama Mahasiswa'),
                _buatInput(jurusanController, 'Masukkan Nama Jurusan'),
                ElevatedButton(
                  child: const Text('Edit Mahasiswa'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nama = namaController.text;
                      String jurusan = jurusanController.text;
                      // print(nama);
                      putData(id, nama, jurusan).then((result) {
                        //print(result['pesan']);
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var namauser2 = namauser;
                                return AlertDialog(
                                  title: const Text('Data berhasil diupdate'),
                                  // content: const Text('ok'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListData(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
              // Tugas Kelompok • Lanjutkan untuk delete data, edit data, dan rea
            ),
          ),
        ));
  }
}
