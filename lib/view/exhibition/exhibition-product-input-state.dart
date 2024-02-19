import 'package:flutter/material.dart';
import 'package:flutter_scs/view/exhibition/exhibition-product-model.dart';
import 'IdAndValue.dart';
import 'input-page-dropdown-state.dart';

class ExhibitionProgramInputState {
  InputPageDropdownState<String>? unitInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>>? productInputPageDropdownState;
  TextEditingController? qty;
  TextEditingController? disc;
  int? maxStock;
  double? harga;
  TextEditingController? hargaOriginal;
  TextEditingController? stock;
  TextEditingController? message;
  ExhibitionProductModel? exhibitionProductModel;

  ExhibitionProgramInputState({
    this.unitInputPageDropdownState,
    this.productInputPageDropdownState,
    this.qty,
    this.disc,
    this.harga,
    this.hargaOriginal,
    this.message,
    this.exhibitionProductModel,
    this.stock
  });
}