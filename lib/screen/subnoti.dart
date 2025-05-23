import 'package:flutter/material.dart';

class SubnotiPage extends StatelessWidget {
  final num id;
  final String status;
  final String timestamp;
  const SubnotiPage(
      {super.key,
      required this.id,
      required this.status,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
        title: Text(
          '${id} ${status}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(timestamp, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
