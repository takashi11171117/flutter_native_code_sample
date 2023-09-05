import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIKitView extends StatelessWidget {
  const UIKitView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: 'native_view',
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
