import 'dart:convert';

import 'package:coincapp/models/app_config.dart';
import 'package:coincapp/pages/home_page.dart';
import 'package:coincapp/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoadConfig();
  registerHTTPservice();
  runApp(const MyApp());
}

Future<void> LoadConfig() async {
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"]),
  );
}

void registerHTTPservice() {
  GetIt.instance.registerSingleton<HTTPSERVICE>(
    HTTPSERVICE(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCap',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color.fromRGBO(88, 60, 197, 1.0)),
      home: HomePage(),
    );
  }
}