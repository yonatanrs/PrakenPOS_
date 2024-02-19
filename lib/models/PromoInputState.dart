import 'package:flutter/material.dart';
import 'PromoInput.dart';

class PromoInputState {
  List<PromoInput>? promoInput;
  List<dynamic>? dataCustomer = [];
  int? dataCustomerState;
  String? customerId;
  List<dynamic>? dataItem;
  int? dataItemState;
  TextEditingController? nameTextEditingController;

  PromoInputState({this.promoInput, this.dataCustomer, this.dataCustomerState, this.customerId, this.dataItem, this.dataItemState, this.nameTextEditingController});

  PromoInputState copy({promoInput, dataCustomer, dataCustomerState, customerId, dataItem, dataItemState, nameTextEditingController}) {
    return new PromoInputState(
      promoInput: promoInput ?? this.promoInput,
      dataCustomer: dataCustomer ?? this.dataCustomer,
      dataCustomerState: dataCustomerState ?? this.dataCustomerState,
      customerId: customerId ?? this.customerId,
      dataItem: dataItem ?? this.dataItem,
      dataItemState: dataItemState ?? this.dataItemState,
      nameTextEditingController: nameTextEditingController ?? this.nameTextEditingController
    );
  }
}