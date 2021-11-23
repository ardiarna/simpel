import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class IDiskusiRouter {
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {String chatId});
}

class DiskusiRouter implements IDiskusiRouter {
  final Widget Function(User receiver, User me, {String chatId})
      showMessageThread;

  DiskusiRouter({required this.showMessageThread});
  @override
  Future<void> onShowMessageThread(
    BuildContext context,
    User receiver,
    User me, {
    String chatId = '',
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receiver, me, chatId: chatId),
      ),
    );
  }
}
