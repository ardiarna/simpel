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
        conflictAlgorithm: ConflictAlgorithm.replace,
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
      await txn.update(
        'chats',
        {'updated_at': message.message.timestamp.toString()},
        where: 'id = ?',
        whereArgs: [message.chatId],
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
      final listOfChatMaps =
          await txn.query('chats', orderBy: 'updated_at DESC');

      if (listOfChatMaps.isEmpty) return [];

      return await Future.wait(listOfChatMaps.map<Future<Chat>>((row) async {
        final unread = Sqflite.firstIntValue(
          await txn.rawQuery(
              'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
              [row['id'], 'deliverred']),
        );
        final mostRecentMessage = await txn.query('messages',
            where: 'chat_id = ?',
            whereArgs: [row['id']],
            orderBy: 'created_at DESC',
            limit: 1);
        final chat = Chat.dariMap(row);
        chat.unread = unread ?? 0;
        if (mostRecentMessage.isNotEmpty)
          chat.mostRecent = LocalMessage.dariMap(mostRecentMessage.first);
        return chat;
      }));
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
      if (mostRecentMessage.isNotEmpty)
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
