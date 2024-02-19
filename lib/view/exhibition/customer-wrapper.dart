import 'package:flutter/material.dart';

class CustomerWrapper {
  TextEditingController? customerNameTextEditingController;
  TextEditingController? noTelpTextEditingController;
  TextEditingController? emailTextEditingController;
  TextEditingController? addressTextEditingController;

  CustomerWrapper({
    this.customerNameTextEditingController,
    this.noTelpTextEditingController,
    this.emailTextEditingController,
    this.addressTextEditingController,
  });

  CustomerWrapper copy({
    TextEditingController? customerNameTextEditingController,
    TextEditingController? noTelpTextEditingController,
    TextEditingController? emailTextEditingController,
    TextEditingController? addressTextEditingController
  }) {
    return CustomerWrapper(
      customerNameTextEditingController: customerNameTextEditingController ?? this.customerNameTextEditingController,
      noTelpTextEditingController: noTelpTextEditingController ?? this.noTelpTextEditingController,
      emailTextEditingController: emailTextEditingController ?? this.emailTextEditingController,
      addressTextEditingController: addressTextEditingController ?? this.addressTextEditingController
    );
  }
}