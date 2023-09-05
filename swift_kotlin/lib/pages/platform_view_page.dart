import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_code_sample/hybrid_composition.dart';
import 'package:flutter_native_code_sample/virtual_display.dart';

class PlatformViewPage extends StatefulWidget {
  const PlatformViewPage({Key? key}) : super(key: key);

  @override
  PlatformViewPageState createState() => PlatformViewPageState();
}

class PlatformViewPageState extends State<PlatformViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform View Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// PlatFormView Android
            Platform.isAndroid
                ? const Center(
                    child: SizedBox(height: 100, child: VirtualDisplay()))
                : const SizedBox.shrink(),
            Platform.isAndroid
                ? const Center(
                    child: SizedBox(height: 100, child: HybridComposition()))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
