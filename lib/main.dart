import 'package:flutter/material.dart';
import 'drill_down_treemap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Sales Treemap',
      home: const CenteredSizedBox(),
    );
  }
}
