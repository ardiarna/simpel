import 'dart:async';
import 'dart:math';

import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/services/message_service_contract.dart';
import 'package:simpel/utils/db_helper.dart';

class MessageService implements IMessageService {
  final _strKontrol = StreamController<Message>.broadcast();
  StreamSubscription? _changefeed;

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _strKontrol.stream;
  }

  @override
  Future<Message> send(Message message) async {
    var map = message.keMap();
    var a = await DBHelper.setData(
      rute: 'chat',
      mode: 'sendmessage',
      body: map,
    );

    if (a['status'].toString() == '1') {
      return Message.dariMap(a['data']);
    } else {
      var r = Random();
      const _chars = 'fufFRXWNKJsdjjmjRMINYUgyf776FFg120987654321';
      String rString =
          List.generate(17, (index) => _chars[r.nextInt(_chars.length)]).join();
      var b = {
        'sender': message.from,
        'receiver': message.to,
        'created_at': message.timestamp,
        'contents': message.contents,
        'id': rString,
      };
      return Message.dariMap(b);
    }
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

  @override
  dispose() {
    _changefeed?.cancel();
    _strKontrol.close();
  }
}
