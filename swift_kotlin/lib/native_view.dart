import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeView extends StatelessWidget {
  const NativeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: 'text',
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
