import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicMessageChannelPage extends StatefulWidget {
  const BasicMessageChannelPage({Key? key}) : super(key: key);

  @override
  BasicMessageChannelPageState createState() => BasicMessageChannelPageState();
}

class BasicMessageChannelPageState extends State<BasicMessageChannelPage> {
  final _basicMessageChannel =
      const BasicMessageChannel('message', StringCodec());

  late String _platformMessage;

  void _sendMessage() async {
    final reply = await _basicMessageChannel.send('Hello World from flutter');
    print(reply);
  }

  @override
  initState() {
    super.initState();

    _basicMessageChannel.setMessageHandler((Object? message) async {
      print('Received message = $message');
      setState(() => _platformMessage = message.toString());
      return 'Reply from Dart';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic MessageChannel Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            _sendMessage();
          },
          child: const Text('メッセージ送信'),
        ),
      ),
    );
  }
}
