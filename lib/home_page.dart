import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Halamanpertama extends StatefulWidget {
  const Halamanpertama({super.key});

  @override
  State<Halamanpertama> createState() => _HalamanpertamaState();
}

class _HalamanpertamaState extends State<Halamanpertama> {
  List<dynamic> customers = [];
  int page = 1;
  int limit = 10;

  bool isloading = false;
  bool isSearchLoading = false;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });

    String url = 'https://retoolapi.dev/yZjtsj/customers?_$page=&_limit=$limit';

    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.addAll(data);
        isloading = false;
      });
    } catch (error) {
      print('Error data: $error');
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> searchData() async {
    setState(() {
      isSearchLoading = true;
      isSearchActive = true;
    });
    String customerName = searchController.text;
    String url =
        'https://retoolapi.dev/yZjtsj/customers?customer_name=$customerName';
    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      setState(() {
        customers.clear();
        customers.addAll(data);
        isSearchLoading = false;
      });
    } catch (error) {
      print('Error data: $error');
      setState(() {
        isSearchLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DAFTAR PELANGGAN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'cari nama pelanggan',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: searchData, child: const Text("Cari")),
                    SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSearchActive = false;
                          page = 1;
                          fetchData();
                        });
                      },
                      child: const Text('Load')),
                ],
              )
            ],
          ),
          Expanded(
            child: isSearchActive
                ? ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(customers[index]['customer_name']),
                        subtitle: Text(customers[index]['email']),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/customerDetail',
                            arguments: customers[index]['id'],
                          );
                        },
                      );
                    },
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isloading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          customers.isNotEmpty) {
                        setState(() {
                          page++;
                        });
                        fetchData();
                      }
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: customers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == customers.length) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text(customers[index]['customer_name']),
                            subtitle: Text(customers[index]['email']),
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                '/customerDetail',
                                arguments: customers[index]['id'].toString(),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
