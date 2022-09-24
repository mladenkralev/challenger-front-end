import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/android/EntryPageAndroid.dart';
import 'package:challenger/web/EntryPageWeb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print(kIsWeb);
    if (kIsWeb) {
      // running on the web!
      return EntryPageWeb();
    } else {
      // android
      return EntryPage();
    }
  }
}
