import 'package:flutter/cupertino.dart';
import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/local_message_model.dart';

abstract class BaseViewModel {
  IDataSource _dataSource;

  BaseViewModel(this._dataSource);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId)) {
      final chat = Chat(message.chatId, ChatType.individual, membersId: [
        {message.chatId: ""}
      ]);
      await createNewChat(chat);
    }
    await _dataSource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != null;
  }

  Future<void> createNewChat(Chat chat) async {
    await _dataSource.addChat(chat);
  }
}
