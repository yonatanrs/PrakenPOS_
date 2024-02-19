import 'package:dio/dio.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CustomerController extends GetxController with StateMixin<CustomerModel> {

  void getListCustomer(String idSales) async {
    change(null, status: RxStatus.loading());
    try {
      var response;
      response = await Customer.getCustomer(idSales, 3);
      if (response.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(CustomerModel(listCustomer: response, customer: null),
            status: RxStatus.success());
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        change(null, status: RxStatus.error("No Connection"));
      } else if (e.type == DioErrorType.cancel) {
        change(null, status: RxStatus.error("No Connection"));
      } else {
        change(null, status: RxStatus.error("Error"));
      }
    }
  }

  void selectDataCustomer(
      List<Customer> listCustomer, Customer customer) async {
    change(null, status: RxStatus.loading());
    change(CustomerModel(listCustomer: listCustomer, customer: customer),
        status: RxStatus.success());
  }
}

class CustomerModel {
  List<Customer>? listCustomer;
  Customer? customer;
  CustomerModel({this.listCustomer, this.customer});
}
