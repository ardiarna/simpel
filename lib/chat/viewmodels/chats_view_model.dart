import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/chat/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;
  IUserService _userService;
  ChatsViewModel(this._dataSource, this._userService) : super(_dataSource);

  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    await Future.forEach<Chat>(chats, (Chat chat) async {
      final ids = chat.membersId.map<String>((e) => e.keys.first).toList();
      final users = await _userService.fetch(ids);
      chat.members = users;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    final chatId = (message.groupId != null && message.groupId != '')
        ? message.groupId
        : message.from;
    LocalMessage localMessage = LocalMessage(
      chatId: chatId ?? message.from,
      message: message,
      receipt: ReceiptStatus.deliverred,
    );
    await addMessage(localMessage);
  }
}
