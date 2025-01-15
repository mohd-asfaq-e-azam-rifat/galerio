import 'dart:async';

Future<void> delay({
  int milliseconds = 3000,
}) async {
  return Future.delayed(
    Duration(milliseconds: milliseconds),
  );
}

Future<T?> delayWithAction<T>({
  int milliseconds = 3000,
  FutureOr<T> Function()? action,
}) async {
  return Future.delayed(
    Duration(milliseconds: milliseconds),
    action,
  );
}
