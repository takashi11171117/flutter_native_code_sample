import 'package:flutter/material.dart';
import 'package:flutter_native_code_sample/pages/event_channel_page.dart';
import 'package:flutter_native_code_sample/pages/method_channel_page.dart';
import 'package:flutter_native_code_sample/pages/platform_view_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter with native code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter with native code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const EventChannelPage(),
                  ),
                );
              },
              child: const Text('Event Channel Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const MethodChannelPage(),
                  ),
                );
              },
              child: const Text('Method Channel Demo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const PlatformViewPage(),
                  ),
                );
              },
              child: const Text('Platform View Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
