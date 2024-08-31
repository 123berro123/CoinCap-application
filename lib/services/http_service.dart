import 'package:dio/dio.dart';
import 'package:coincapp/models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPSERVICE {
  final Dio dio = Dio();
  AppConfig? _appconfig;
  String? _base_url;

  HTTPSERVICE() {
    _appconfig = GetIt.instance.get<AppConfig>();
    _base_url = _appconfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$_base_url$_path";
      Response _response = await dio.get(_url);
      return _response;
    } catch (e) {
      print('HTTP Service: unable to perform a get request');
      print(e);
    }
  }
}
