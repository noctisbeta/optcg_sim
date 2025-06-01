import 'package:admin_dashboard/add_card_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Admin Dashboard',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const AddCardView(),
  );
}
