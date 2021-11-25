import 'package:flutter/material.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/utils/af_convert.dart';

class SenderMessage extends StatelessWidget {
  final LocalMessage _message;

  const SenderMessage(this._message);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 0.75,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  position: DecorationPosition.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text(
                      _message.message.contents.trim(),
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      AFconvert.matDateTime(_message.message.timestamp),
                      style: Theme.of(context)
                          .textTheme
                          .overline!
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: _message.receipt == ReceiptStatus.read
                      ? Colors.green.shade700
                      : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
