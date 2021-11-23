import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalCache {
  Future<void> save(String key, Map<String, dynamic> map);
  Map<String, dynamic> fetch(String key);
}

class LocalCache implements ILocalCache {
  final SharedPreferences _sharedPreferences;

  LocalCache(this._sharedPreferences);

  @override
  Map<String, dynamic> fetch(String key) {
    var a = _sharedPreferences.getString(key);
    if (a != null) {
      return jsonDecode(a);
    } else {
      return {};
    }
  }

  @override
  Future<void> save(String key, Map<String, dynamic> map) async {
    await _sharedPreferences.setString(key, jsonEncode(map));
  }
}
