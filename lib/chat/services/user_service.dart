import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/utils/db_helper.dart';

class UserService implements IUserService {
  @override
  Future<User> connect(User user) async {
    var data = user.keMap();
    if (user.idn != '') data['id'] = user.idn;

    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'connect',
      body: data,
    );

    return a != null ? User.dariMap(a) : User();
  }

  @override
  Future<void> disconnect(User user) async {
    var data = user.keMap();
    await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'disconnect',
      body: data,
    );
  }

  @override
  Future<List<User>> online() async {
    List<User> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'online',
      body: {'active': 'Y'},
    );
    for (var el in a) {
      var b = User.dariMap(el);
      list.add(b);
    }
    return list;
  }

  @override
  Future<User> fetch(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'getuser',
      body: {'nik': nik},
    );

    return a != null ? User.dariMap(a) : User();
  }
}
