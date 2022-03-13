import 'package:challenger/configuration.dart';
import 'package:challenger/screens/entry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return EntryPage();
  }
}
