import 'package:flutter/cupertino.dart';

import '../view/input-page/input-page-dropdown-state.dart';
import 'IdAndValue.dart';

class PromotionProgramInputState {
  InputPageDropdownState<String>? customerGroupInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>>? customerNameOrDiscountGroupInputPageDropdownState;
  InputPageDropdownState<String>? itemGroupInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>>? selectProductPageDropdownState;
  WrappedInputPageDropdownState<IdAndValue<String>>? wareHousePageDropdownState;
  WrappedInputPageDropdownState<IdAndValue<String>>? productTransactionPageDropdownState;
  TextEditingController? qtyFrom;
  TextEditingController? qtyTo;
  TextEditingController? qtyTransaction;
  TextEditingController? priceTransaction;
  TextEditingController? discTransaction;
  TextEditingController? totalTransaction;
  InputPageDropdownState<String>? currencyInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>>? percentValueInputPageDropdownState;
  InputPageDropdownState<String>? unitPageDropdownState;
  InputPageDropdownState<IdAndValue<String>>? multiplyInputPageDropdownState;
  TextEditingController? fromDate;
  TextEditingController? toDate;
  TextEditingController? percent1;
  TextEditingController? percent2;
  TextEditingController? percent3;
  TextEditingController? percent4;
  TextEditingController? salesPrice;
  TextEditingController? priceToCustomer;
  TextEditingController? value1;
  TextEditingController? value2;
  InputPageDropdownState<IdAndValue<String>>? supplyItem;
  TextEditingController? qtyItem;
  InputPageDropdownState<String>? unitSupplyItem;

  PromotionProgramInputState({
    this.customerGroupInputPageDropdownState,
    this.customerNameOrDiscountGroupInputPageDropdownState,
    this.itemGroupInputPageDropdownState,
    this.selectProductPageDropdownState,
    this.wareHousePageDropdownState,
    this.productTransactionPageDropdownState,
    this.qtyFrom,
    this.qtyTo,
    this.currencyInputPageDropdownState,
    this.percentValueInputPageDropdownState,
    this.unitPageDropdownState,
    this.multiplyInputPageDropdownState,
    this.fromDate,
    this.toDate,
    this.percent1,
    this.percent2,
    this.percent3,
    this.percent4,
    this.salesPrice,
    this.priceToCustomer,
    this.value1,
    this.value2,
    this.supplyItem,
    this.qtyItem,
    this.unitSupplyItem,
    this.qtyTransaction,
    this.discTransaction,
    this.priceTransaction,
    this.totalTransaction,
  });
}