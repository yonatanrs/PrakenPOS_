import 'package:flutter_scs/mobile_sms/lib/models/promotion-program-input-state.dart';

class InputPageWrapper {
  List<PromotionProgramInputState>? promotionProgramInputState;
  List<String>? originalPrice = [];
  bool? isAddItem;

  InputPageWrapper({
    this.promotionProgramInputState,
    this.isAddItem
  });

  InputPageWrapper copy({
    List<PromotionProgramInputState>? promotionProgramInputState,
    bool? isAddItem
  }) {
    return InputPageWrapper(
      promotionProgramInputState: promotionProgramInputState ?? this.promotionProgramInputState,
      isAddItem: isAddItem ?? this.isAddItem
    );
  }
}