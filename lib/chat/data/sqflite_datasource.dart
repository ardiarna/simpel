import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:sqflite/sqflite.dart';

class SqfLiteDataSource implements IDataSource {
  final Database _db;

  const SqfLiteDataSource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert(
        'chats',
        chat.keMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert(
        'messages',
        message.keMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage = await txn.rawQuery(''' SELECT messages.* 
      FROM
      (
        SELECT chat_id, MAX(created_at) AS created_at
        FROM messages
        GROUP BY chat_id
      ) AS latest_messages 
      INNER JOIN messages
      ON messages.chat_id = latest_messages.chat_id
      AND messages.created_at = latest_messages.created_at
      ORDER BY messages.created_at DESC''');

      if (chatsWithLatestMessage.isEmpty) return [];

      final chatsWithUnreadMessages =
          await txn.rawQuery(''' SELECT chat_id, count(*) AS unread
      FROM messages
      WHERE receipt = ?
      GROUP BY chat_id
      ''', ['deliverred']);
      return chatsWithLatestMessage.map<Chat>((row) {
        final int unread = int.tryParse(chatsWithUnreadMessages
                .firstWhere((ele) => row['chat_id'] == ele['chat_id'],
                    orElse: () => {'unread': 0})['unread']
                .toString()) ??
            0;

        final chat = Chat.dariMap({'id': row['chat_id']});
        chat.unread = unread;
        chat.mostRecent = LocalMessage.dariMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(
        await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred'],
        ),
      );

      final mostRecentMessage = await txn.query(
        'messages',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      final chat = Chat.dariMap(listOfChatMaps.first);
      chat.unread = unread ?? 0;
      chat.mostRecent = LocalMessage.dariMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );
    return listOfMaps
        .map<LocalMessage>((e) => LocalMessage.dariMap(e))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update(
      'messages',
      message.keMap(),
      where: 'id = ?',
      whereArgs: [message.message.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _db.transaction((txn) async {
      await txn.update(
        'messages',
        {'receipt': status.value()},
        where: 'id = ?',
        whereArgs: [messageId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
