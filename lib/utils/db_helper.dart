import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum MethodeRequest {
  post,
  get,
  multipartRequest,
}

abstract class DBHelper {
  static const String dirBase = 'http://10.0.2.2/salamdesa/';
  // static const String dirBase =
  //     'http://salamdesa.bbplm-jakarta.kemendesa.go.id/';
  static const String dirImage = dirBase + 'image/';
  static const String api = dirBase + 'api/';

  static Future<Map<String, dynamic>?> getData({
    MethodeRequest methodeRequest = MethodeRequest.get,
    required String rute,
    String mode = '',
    Map<String, String>? body,
    Map<String, String>? header,
    Encoding? encoding,
  }) async {
    mode = mode != '' ? '/$mode' : '';
    late Response resp;
    if (methodeRequest == MethodeRequest.post) {
      resp = await http.post(
        Uri.parse(api + rute + mode),
        body: body,
        headers: header,
        encoding: encoding,
      );
    } else {
      resp = await http.get(
        Uri.parse(api + rute + mode),
        headers: header,
      );
    }
    var jd = jsonDecode(resp.body);
    return jd['data'];
  }

  static Future<Map<String, dynamic>> setData({
    MethodeRequest methodeRequest = MethodeRequest.post,
    required String rute,
    String mode = '',
    Map<String, String>? body,
    Map<String, String>? header,
    Map<String, String>? filePath,
    Encoding? encoding,
  }) async {
    mode = mode != '' ? '/$mode' : '';
    if (methodeRequest == MethodeRequest.multipartRequest) {
      var req = http.MultipartRequest('POST', Uri.parse(api + rute + mode));
      if (body != null) {
        body.forEach((key, value) {
          req.fields[key] = value;
        });
      }
      if (filePath != null) {
        filePath.forEach((key, value) async {
          var pic = await http.MultipartFile.fromPath(key, value);
          req.files.add(pic);
        });
      }
      var resp = await req.send();
      var respData = await resp.stream.toBytes();
      var respString = String.fromCharCodes(respData);
      return jsonDecode(respString);
    } else {
      Response resp = await http.post(
        Uri.parse(api + rute + mode),
        body: body,
        headers: header,
        encoding: encoding,
      );
      return jsonDecode(resp.body);
    }
  }

  static Future<List<dynamic>> getDaftar({
    MethodeRequest methodeRequest = MethodeRequest.get,
    required String rute,
    String mode = '',
    Map<String, String>? body,
    Map<String, String>? header,
    Encoding? encoding,
  }) async {
    mode = mode != '' ? '/$mode' : '';
    late Response resp;
    if (methodeRequest == MethodeRequest.post) {
      resp = await http.post(
        Uri.parse(api + rute + mode),
        body: body,
        headers: header,
        encoding: encoding,
      );
    } else {
      resp = await http.get(
        Uri.parse(api + rute + mode),
        headers: header,
      );
    }
    var jd = jsonDecode(resp.body);
    return jd['data'];
  }
}
