import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VirtualDisplay extends StatelessWidget {
  const VirtualDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: 'native_view',
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
