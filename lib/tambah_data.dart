import 'dart:convert';
import 'dart:io';
import 'package:taskmanager/home_page.dart';
import 'package:taskmanager/list_data.dart';
import 'package:taskmanager/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  Future postData(String task) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'http://10.98.5.28/taskmanager/index.php'
        : 'http://localhost/taskmanager/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"task": "$task"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
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
          title: const Text('Tambah Data Task'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(taskController, 'Masukkan Task'),
                ElevatedButton(
                  child: const Text('Tambah Task'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String task = taskController.text;
                      // print(nama);
                      postData(task).then((result) {
                        //print(result['pesan']);
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                //var namauser2 = namauser;
                                return AlertDialog(
                                  title: const Text('Data berhasil ditambah'),
                                  // content: const Text('ok'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
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
