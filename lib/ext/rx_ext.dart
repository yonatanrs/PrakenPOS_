import 'package:get/get.dart';

extension RxObjectMixinExt<T> on RxObjectMixin<T> {
  void valueFromLast(T Function(T) onCopy) {
    value = onCopy(value);
  }
}