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
    await Future.forEach<Chat>(chats, (chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
      chatId: message.from,
      message: message,
      receipt: ReceiptStatus.deliverred,
    );
    await addMessage(localMessage);
  }
}
