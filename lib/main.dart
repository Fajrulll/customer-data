import 'package:data_pelanggan/customer_detail.dart';
import 'package:data_pelanggan/home_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'data customer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Halamanpertama(),
        '/customerDetail': (context) => const CustomerDetailPage(),
      },
    );
  }
}
