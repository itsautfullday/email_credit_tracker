import 'package:flutter/material.dart';

class ViewScaffold extends StatelessWidget {
  final Widget body;
  Widget? floatingActionButton;

  ViewScaffold({super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text("Simple Transactions Manager",
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: this.body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
