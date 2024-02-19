import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debounce {
  final int miliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({required this.miliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: miliseconds), action);
  }
}
