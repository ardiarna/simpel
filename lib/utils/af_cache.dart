import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AFcache {
  Future setUser(String id) async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.setString('id', id);
  }

  Future<String?> cekUserId() async {
    final _pref = await StreamingSharedPreferences.instance;
    var id = _pref.getString('id', defaultValue: '').getValue();
    return id == '' ? null : id;
  }

  Future<MemberModel> getUser() async {
    final _pref = await StreamingSharedPreferences.instance;
    final MemberBloc _memberBloc = MemberBloc();
    var a = await _memberBloc
        .getMember(_pref.getString('id', defaultValue: '').getValue());
    return a;
  }

  Future removeUser() async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.remove('id');
  }

  Future clear() async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.clear();
  }
}
