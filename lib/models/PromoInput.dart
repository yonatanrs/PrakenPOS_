import 'package:flutter/cupertino.dart';

class PromoInput {
  TextEditingController? qtyTextInputController;
  TextEditingController? discountTextInputController;
  TextEditingController? priceTextInputController;
  String? itemId;
  String? unit;
  int? dataUnitState;
  List<dynamic>? dataUnit;

  PromoInput({
    this.qtyTextInputController,
    this.discountTextInputController,
    this.priceTextInputController,
    this.itemId,
    this.unit,
    this.dataUnitState,
    this.dataUnit
  });
}
