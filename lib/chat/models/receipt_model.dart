import 'package:simpel/utils/af_convert.dart';

enum ReceiptStatus { sent, deliverred, read }

extension ReceiptStatusParser on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class Receipt {
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final DateTime? timestamp;
  String _id = '';
  String get id => _id;

  Receipt({
    this.recipient = '',
    this.messageId = '',
    this.status = ReceiptStatus.sent,
    this.timestamp,
  });

  factory Receipt.dariMap(Map<String, dynamic> map) {
    final receipt = Receipt(
      recipient: AFconvert.keString(map['recipient']),
      messageId: AFconvert.keString(map['message_id']),
      timestamp: AFconvert.keTanggal(map['created_at']),
      status: ReceiptStatusParser.fromString(map['status']),
    );
    receipt._id = AFconvert.keString(map['id']);
    return receipt;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'recipient': recipient,
      'message_id': messageId,
      'status': status.value(),
      'created_at': AFconvert.keString(timestamp),
    };
    return map;
  }
}
