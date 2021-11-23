import 'dart:async';

import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/services/message_service_contract.dart';
import 'package:simpel/utils/db_helper.dart';

class MessageService implements IMessageService {
  final _strKontrol = StreamController<Message>.broadcast();
  StreamSubscription? _changefeed;

  @override
  dispose() {
    _strKontrol.close();
    _changefeed?.cancel();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _strKontrol.stream;
  }

  @override
  Future<Message> send(Message message) async {
    var map = message.keMap();
    await DBHelper.setData(
      rute: 'chat',
      mode: 'sendmessage',
      body: map,
    );
    // if (a['status'].toString() == '1') {
    //   return true;
    // } else {
    //   return false;
    // }
    return message;
  }

  Stream<List<Message>> _getDaftar(User user) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      List<Message> list = [];
      var a = await DBHelper.getDaftar(
        methodeRequest: MethodeRequest.post,
        rute: 'chat',
        mode: 'getmessage',
        body: {'receiver': user.nik},
      );
      for (var el in a) {
        var b = Message.dariMap(el);
        list.add(b);
      }
      yield list;
    }
  }

  _startReceivingMessages(User user) {
    _changefeed = _getDaftar(user).listen((event) {
      event.forEach((message) {
        _strKontrol.sink.add(message);
        _removeDeliverredMessage(message);
      });
    });
  }

  _removeDeliverredMessage(Message message) async {
    await DBHelper.setData(
      rute: 'chat',
      mode: 'delmessage',
      body: {'id': message.id},
    );
  }
}