import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';

const defaultDebounceTime = 300;

@injectable
class DebounceHelper {
  Timer? _timer;

  void run(
    VoidCallback action, {
    int milliseconds = defaultDebounceTime,
  }) {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
  }
}
