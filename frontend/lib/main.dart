import 'package:flutter/material.dart';
import 'features/product/presentation/pages/product_list_page.dart';

void main() {
  runApp(const MenlyApp());
}

class MenlyApp extends StatelessWidget {
  const MenlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const ProductListPage(),
    );
  }
}
