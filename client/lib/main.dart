import 'package:client/extended_board.dart';
import 'package:client/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ProviderWrapper());
}

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (context) => GameController(), child: const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: ExtendedBoard()),
  );
}
