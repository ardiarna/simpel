import 'dart:async';

import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/services/receipt_service_contract.dart';
import 'package:simpel/utils/db_helper.dart';

class ReceiptService implements IReceiptService {
  final _strKontrol = StreamController<Receipt>.broadcast();
  StreamSubscription? _changefeed;

  @override
  dispose() {
    _strKontrol.close();
    _changefeed?.cancel();
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _strKontrol.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    var map = receipt.keMap();
    var a = await DBHelper.setData(
      rute: 'chat',
      mode: 'sendreceipt',
      body: map,
    );
    if (a['status'].toString() == '1') {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<Receipt>> _getDaftar(User user) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      List<Receipt> list = [];
      var a = await DBHelper.getDaftar(
        methodeRequest: MethodeRequest.post,
        rute: 'chat',
        mode: 'getreceipt',
        body: {'recipient': user.nik},
      );
      for (var el in a) {
        var b = Receipt.dariMap(el);
        list.add(b);
      }
      yield list;
    }
  }

  _startReceivingReceipts(User user) {
    _changefeed = _getDaftar(user).listen((event) {
      event.forEach((receipt) {
        _strKontrol.sink.add(receipt);
        _removeDeliverredRrceipt(receipt);
      });
    });
  }

  _removeDeliverredRrceipt(Receipt receipt) async {
    await DBHelper.setData(
      rute: 'chat',
      mode: 'delreceipt',
      body: {'id': receipt.id},
    );
  }
}
