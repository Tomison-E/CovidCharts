import 'dart:io';

import 'package:dio/dio.dart';

class Api {
  final String latestBaseUrl = "https://api.apify.com/v2/key-value-stores/Eb694wt67UxjdSGbc/records/LATEST";
  final String historyBaseUrl = "https://api.apify.com/v2/datasets/ccY329O0ng68poTiX/items?format=json&clean=1";
  final String regionalBaseUrl = "https://covik-119.herokuapp.com/view";

  Dio http = new Dio();


  Future<Response> getLatest() async {
    final Map<String ,String> headers = {
      HttpHeaders.acceptHeader:"application/json",// or whatever
    };
    final res = await http.get("$latestBaseUrl",options: Options(
        headers: headers
    ));
    return res;
  }

  Future<Response> getHistorical() async {
    final Map<String ,String> headers = {
      HttpHeaders.acceptHeader:"application/json",// or whatever
    };
    final res = await http.get("$historyBaseUrl",options: Options(
        headers: headers
    ));
    return res;
  }

  Future<Response> getRegional() async {
    final Map<String ,String> headers = {
      HttpHeaders.acceptHeader:"application/json",// or whatever
    };
    final res = await http.get("$regionalBaseUrl",options: Options(
        headers: headers
    ));
    return res;
  }
}