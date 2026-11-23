import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const _ParleyApp());
}

class const _ParleyApp() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parley',
      debugShowCheckedModeBanner: false,
      home: const _ParleyContent(),
    );
  }
}

class const _ParleyContent() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Ich bin hier",
        ),
      ),
    );
  }
}
