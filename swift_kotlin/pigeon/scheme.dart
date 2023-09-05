import 'package:pigeon/pigeon.dart';

class Message {
  String? content;
}

@HostApi()
abstract class MessageApi {
  void sendMessage(Message msg);
  Message receiveMessage();
}
