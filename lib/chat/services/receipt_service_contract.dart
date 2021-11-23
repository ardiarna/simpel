import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> receipts(User user);
  dispose();
}
