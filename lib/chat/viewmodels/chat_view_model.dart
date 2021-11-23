import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  IDataSource _dataSource;
  String _chatId = '';
  int otherMessage = 0;
  String get chatId => _chatId;
  ChatViewModel(this._dataSource) : super(_dataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
      chatId: message.to,
      message: message,
      receipt: ReceiptStatus.sent,
    );
    if (_chatId.isNotEmpty) return await _dataSource.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
      chatId: message.from,
      message: message,
      receipt: ReceiptStatus.deliverred,
    );
    if (_chatId.isEmpty) _chatId = localMessage.chatId;
    if (localMessage.chatId != _chatId) otherMessage++;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _dataSource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
