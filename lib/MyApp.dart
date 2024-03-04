import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/web/EntryPageWeb.dart';
import 'package:flutter/material.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // running on the web!
    return EntryPageWeb();
  }
}
