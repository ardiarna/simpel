import 'dart:async';
import 'dart:math';

import 'package:simpel/chat/models/message_group_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/db_helper.dart';

abstract class IGroupService {
  Future<MessageGroup> create(MessageGroup messageGroup);
  Stream<MessageGroup> groups({required User me});
  dispose();
}

class MessageGroupService implements IGroupService {
  final _strKontrol = StreamController<MessageGroup>.broadcast();
  StreamSubscription? _changefeed;

  @override
  Future<MessageGroup> create(MessageGroup messageGroup) async {
    var map = messageGroup.keMap();
    var a = await DBHelper.setData(
      rute: 'chat',
      mode: 'sendmessagegroup',
      body: map,
    );

    if (a['status'].toString() == '1') {
      return MessageGroup.dariMap(a['data']);
    } else {
      var r = Random();
      const _chars = 'fufFRXWNKJsdjjmjRMINYUgyf776FFg1209dsds87654321';
      String rString =
          List.generate(27, (index) => _chars[r.nextInt(_chars.length)]).join();
      var b = {
        'name': messageGroup.name,
        'created_by': messageGroup.createdBy,
        'members': messageGroup.members,
        'id': rString,
      };
      return MessageGroup.dariMap(b);
    }
  }

  @override
  Stream<MessageGroup> groups({required User me}) {
    _startReceivingMessages(me);
    return _strKontrol.stream;
  }

  _startReceivingMessages(User user) {
    _changefeed = _getDaftar(user).listen((event) {
      event.forEach((messageGroup) {
        _strKontrol.sink.add(messageGroup);
        _updateWhenReceivedGroupCreated(messageGroup, user);
      });
    });
  }

  _updateWhenReceivedGroupCreated(MessageGroup messageGroup, User user) async {
    var a = await DBHelper.setData(
      rute: 'chat',
      mode: 'receivedmessagegroup',
      body: {'name': messageGroup.name, 'nik': user.nik},
    );

    if (a['status'].toString() == '1') {
      _removeGroupWhenDeliverredToAll(a['data']);
    }
  }

  _removeGroupWhenDeliverredToAll(Map nilai) async {
    final List members = AFconvert.keList(nilai['members']);
    final List alreadyReceived = AFconvert.keList(nilai['received_by']);
    final String name = AFconvert.keString(nilai['name']);
    if (members.length > alreadyReceived.length) return;
    await DBHelper.setData(
      rute: 'chat',
      mode: 'delmessagegroup',
      body: {'name': name},
    );
  }

  Stream<List<MessageGroup>> _getDaftar(User user) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      List<MessageGroup> list = [];
      var a = await DBHelper.getDaftar(
        methodeRequest: MethodeRequest.post,
        rute: 'chat',
        mode: 'getmessagegroup',
        body: {'nik': user.nik},
      );
      for (var el in a) {
        var b = MessageGroup.dariMap(el);
        list.add(b);
      }
      yield list;
    }
  }

  @override
  dispose() {
    _changefeed?.cancel();
    _strKontrol.close();
  }
}
