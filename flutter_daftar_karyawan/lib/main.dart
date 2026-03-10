import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/karyawan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<List<Karyawan>> _readJsonData() async {
    final String response = await rootBundle.loadString('assets/karyawan.json');
    final List<dynamic> data = json.decode(response);
    //log(data.toString());
    // print(data);
    return data.map((json) => Karyawan.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Daftar Karyawan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Karyawan>>(
          future: _readJsonData(),
          builder: (context, snapshot) {
            //print('data =' + snapshot.hasData.toString());
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final karyawan = snapshot.data![index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(
                        color: Colors.blueGrey,
                        width: 1.0,
                      ),
                    ),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: Text(
                              karyawan.nama.isNotEmpty
                                  ? karyawan.nama[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  karyawan.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      size: 16.0,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text('Umur: ${karyawan.umur}'),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        '${karyawan.alamat.jalan}, ${karyawan.alamat.kota}, ${karyawan.alamat.provinsi}',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
