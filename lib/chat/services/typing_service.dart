import 'dart:async';

import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/services/typing_service_contract.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/utils/db_helper.dart';

class TypingNotification implements ITypingNotification {
  final _strKontrol = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changefeed;
  IUserService _userService;

  TypingNotification(this._userService);

  @override
  dispose() {
    _strKontrol.close();
    _changefeed?.cancel();
  }

  @override
  Future<bool> send({required TypingEvent event}) async {
    final receiver = await _userService.fetch(event.to);
    if (!receiver.active) return false;
    var map = event.keMap();
    var a = await DBHelper.setData(
      rute: 'chat',
      mode: 'sendtyping',
      body: map,
    );
    if (a['status'].toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypings(user, userIds);
    return _strKontrol.stream;
  }

  Stream<List<TypingEvent>> _getDaftar(User user, List<String> userIds) async* {
    List<String> withKutip = userIds.map((e) => "'" + e + "'").toList();
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      List<TypingEvent> list = [];
      var a = await DBHelper.getDaftar(
        methodeRequest: MethodeRequest.post,
        rute: 'chat',
        mode: 'gettyping',
        body: {'receiver': user.nik, 'sender': withKutip.join(',')},
      );
      for (var el in a) {
        var b = TypingEvent.dariMap(el);
        list.add(b);
      }
      yield list;
    }
  }

  _startReceivingTypings(User user, List<String> userIds) {
    _changefeed = _getDaftar(user, userIds).listen((event) {
      event.forEach((typing) {
        _strKontrol.sink.add(typing);
        _removeTypings(typing);
      });
    });
  }

  _removeTypings(TypingEvent typing) async {
    await DBHelper.setData(
      rute: 'chat',
      mode: 'deltyping',
      body: {'id': typing.id},
    );
  }
}
