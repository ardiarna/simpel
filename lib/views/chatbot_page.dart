import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late DialogFlowtter dialogFlowtter;

  void respon(query) async {
    DialogAuthCredentials credentials = await DialogAuthCredentials.fromFile(
        "assets/simpel-47-255649899046.json");
    DialogFlowtter dialogFlowtter = DialogFlowtter(credentials: credentials);
    DetectIntentResponse detectIntentResponse =
        await dialogFlowtter.detectIntent(
      queryInput: QueryInput(
        text: TextInput(
          text: query,
        ),
      ),
    );
    List<Message> listMessage = [];
    if (detectIntentResponse.queryResult != null) {
      listMessage = detectIntentResponse.queryResult!.fulfillmentMessages ?? [];
    }
    listMessage.forEach((message) {
      print(message.text!.text![0]);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Test'),
        onPressed: () {
          respon('ekt');
        },
      ),
    );
  }
}
