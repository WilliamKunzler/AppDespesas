import 'package:flutter/material.dart';

class Despesa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.house,
          color: Colors.green,
          size: 30,
        ),
        title: Text("Casa",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        subtitle: Text("20/05/2025", style: TextStyle(fontSize: 15)),
        trailing: Text(
          "10,00 R\$",
          style: TextStyle(color: Colors.red, fontSize: 17),
        ));
  }
}
