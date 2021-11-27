import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/utils/af_widget.dart';

abstract class IDiskusiRouter {
  Future<void> onShowMessageThread({
    required BuildContext context,
    required List<User> receivers,
    required User me,
    required Chat chat,
  });
  Future<void> onShowCreateGroup({
    required BuildContext context,
    required List<User> activeUsers,
    required User me,
  });
}

class DiskusiRouter implements IDiskusiRouter {
  final Widget Function({
    required List<User> receivers,
    required User me,
    required Chat chat,
  }) showMessageThread;

  final Widget Function({
    required List<User> activeUsers,
    required User me,
  }) showCreatedGroup;

  DiskusiRouter({
    required this.showMessageThread,
    required this.showCreatedGroup,
  });

  @override
  Future<void> onShowMessageThread({
    required BuildContext context,
    required List<User> receivers,
    required User me,
    required Chat chat,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(
          receivers: receivers,
          me: me,
          chat: chat,
        ),
      ),
    );
  }

  @override
  Future<void> onShowCreateGroup({
    required BuildContext context,
    required List<User> activeUsers,
    required User me,
  }) async {
    AFwidget.modalBottom(
      context: context,
      konten: showCreatedGroup(
        activeUsers: activeUsers,
        me: me,
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }
}
