import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api.dart';

class PigeonPage extends StatefulWidget {
  const PigeonPage({Key? key}) : super(key: key);

  @override
  PigeonPageState createState() => PigeonPageState();
}

class PigeonPageState extends State<PigeonPage> {
  final _api = MessageApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                Message msg = Message();
                msg.content = "Hello from Dart!";
                await _api.sendMessage(msg);
              },
              child: const Text('Send Message'),
            ),
            ElevatedButton(
              onPressed: () async {
                Message msg = await _api.receiveMessage();
                print("Received message: ${msg.content}");
              },
              child: const Text('Receive Message'),
            ),
          ],
        ),
      ),
    );
  }
}
