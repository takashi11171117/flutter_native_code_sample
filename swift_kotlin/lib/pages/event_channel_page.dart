import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventChannelPage extends StatefulWidget {
  const EventChannelPage({Key? key}) : super(key: key);

  @override
  EventChannelPageState createState() => EventChannelPageState();
}

class EventChannelPageState extends State<EventChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Channel Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<int>(
                stream: _streamCounter(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return Text(
                    '${snapshot.data}',
                    style: const TextStyle(fontSize: 50),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Stream<int> _streamCounter() {
    const counterChannel = EventChannel('counter');
    return counterChannel.receiveBroadcastStream().map((event) {
      return int.parse(event.toString());
    });
  }
}
