import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:taskmanager/side_menu.dart';
import 'package:taskmanager/tambah_data.dart';
import 'package:taskmanager/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> dataTask = [];
  String url = Platform.isAndroid
      ? 'http://10.98.5.28/taskmanager/index.php'
      : 'http://localhost/taskmanager/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode == 200) && response.body != "Data task kosong.") {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataTask = List<Map<String, String>>.from(data.map((item) {
          return {
            'task': item['task'] as String,
            'isfinished': item['isfinished'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    }
  }

  Future putData(int? id) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'http://10.98.5.28/taskmanager/index.php'
        : 'http://localhost/taskmanager/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"id":"$id"}';
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

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Data Task'),
        ),
        drawer: const SideMenu(),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataTask.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataTask[index]['task']!),
                  // ignore: unrelated_type_equality_checks
                  subtitle: Text(dataTask[index]['isfinished'] == "1"
                      ? 'Finished'
                      : 'Not Yet'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          //lihatTask(index);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('${dataTask[index]['task']}'),
                                    content: Text(
                                        dataTask[index]['isfinished'] == "1"
                                            ? 'Finished'
                                            : 'Not Yet')
                                    // actions: [
                                    //   TextButton(
                                    //     child: const Text('OK'),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               const HomePage(),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    //   ],
                                    );
                              });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          putData(int.parse(dataTask[index]['id']!))
                              .then((result) {
                            //print(result['pesan']);
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    //var namauser2 = namauser;
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil diupdate'),
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
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataTask[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil dihapus'),
                                      // content: const Text('ok'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
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
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
