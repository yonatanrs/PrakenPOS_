import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_error.dart';
import 'package:flutter_scs/assets/uistate/widget_state_no_data.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/state_management/getx/CustomerController.dart';
import 'package:flutter_scs/state_management/providers/CustomerProvider.dart';
import 'package:flutter_scs/view/FormNewCustomerView.dart';
import 'package:flutter_scs/view/ListProductView.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCustomerView extends StatefulWidget {
  @override
  _ListCustomerViewState createState() => _ListCustomerViewState();
}

class _ListCustomerViewState extends State<ListCustomerView> {
  TextEditingController _searchboxSegment = TextEditingController();
  late String nameCustomer, address, contact = '';
  late String idSales, idDevice;
  late Customer _selectedCustomer;
  bool isSwitcherCustomer = false;

  var connectivityResult = (Connectivity().checkConnectivity());
  var customerController = Get.put(CustomerController());

  void initState() {
    super.initState();
    _initialData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () => onBackPressLines(),
      child: ChangeNotifierProvider<CustomerProvider>(
        create: (context) => CustomerProvider(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorBlueDark,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorAccent,
              ),
              onPressed: onBackPressLines,
            ),
            title: Text(
              "Choose Customer ",
              style: textHeaderView,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: colorBlueDark,
              onPressed: () => _navigateToNewCustomer(),
              label: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New Customer'),
                  SvgPicture.asset(
                    'lib/assets/icons/Chevron_right.svg',
                    color: colorNetral,
                  )
                ],
              )),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                customerController.obx(
                    (state) => Container(
                        margin: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(10),
                            ScreenUtil().setWidth(5),
                            ScreenUtil().setWidth(5),
                            ScreenUtil().setWidth(5)),
                        child: DropdownSearch<Customer>(
                          validator: (v) => v == null ? "Must be filled" : null,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Choose one customer ",
                              filled: true,
                              fillColor: colorNetral,
                            ),
                          ),
                          popupProps: PopupProps.bottomSheet(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              controller: _searchboxSegment,
                            ),
                            loadingBuilder: (context, searchEntry) {
                              return Container(
                                child: Text('Loading...'),
                              );
                            },
                            emptyBuilder: (context, searchEntry) {
                              return Center(child: Text('Data Not Found'));
                            },
                          ),
                          dropdownButtonProps: DropdownButtonProps(),
                          clearButtonProps: ClearButtonProps(
                            isVisible: true,
                          ),
                          items: state?.listCustomer ?? [], // Provide a non-nullable default value
                          selectedItem: _selectedCustomer,
                          compareFn: (valueReal, value) {
                            return false;
                          },
                          itemAsString: (Customer? item) => item?.nameCust ?? 'Choose one customer',
                          onChanged: (value) {
                            setState(() {
                              _selectedCustomer = value!;
                              print("hello $_selectedCustomer");
                              customerController.selectDataCustomer(
                                  state!.listCustomer!, _selectedCustomer);
                            });
                          },
                        )
                    ), onError: (value) {
                  return WidgetStateError(
                      message: 'Error Unknown', onPressed: _initialData);
                }, onLoading: SizedBox(height: 10,),
                    onEmpty: WidgetStateNoData(
                      message: 'No Data',
                    )),
                customerController.obx((state) => _selectedCustomer != null
                    ? Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorBlueSky),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Code Name'),
                                Expanded(
                                  flex: 1,
                                  child: Text(state!.customer!.codeCust!,
                                      textAlign: TextAlign.right),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Name'),
                                Expanded(
                                  flex: 1,
                                  child: Text(state.customer!.nameCust!,
                                      textAlign: TextAlign.right),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Handphone / Telepon'),
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  state.customer!.contact == '' ? 'No Contact' : state.customer!.contact!,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Alamat'),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    state.customer!.address!,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container()),

                _checkoutSection(
                    _selectedCustomer, nameCustomer, contact, address, )
              ],
            ),
          ),
        ),
      ),
    );
  }

  late String test;
  late String codeName;
  Widget _checkoutSection(
      Customer _customer, String nameCust, String contact, String address) {

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: colorBlueDark,
              )),
          padding: EdgeInsets.all(8),
          backgroundColor: colorNetral,
        ),
        onPressed: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_customer == null && nameCust == null) {
          Fluttertoast.showToast(
              msg:
                  'Tolong pilih pelanggan atau isi lengkap data pelanggan baru.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: colorError,
              textColor: colorFontError,
              fontSize: ScreenUtil().setSp(16));
        } else {
          print("one piece");
          _showAlertDialog(_customer, 1);
        }
        },
        child: Text(
          "SELANJUTNYA",
          style: TextStyle(
              color: colorBlueDark, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAlertDialog(Customer customer, int type) {
    deleteCart();
    if (type == 0) {
      customer.group = "JKT";
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ListProductView(customer: customer, codeCustomer: customer.codeCust,);
    }));
  }

  void deleteCart() async {
    Box _cartBox = await Hive.openBox("carts");
    _cartBox.deleteFromDisk();
  }

  Future<bool> onBackPressLines() async{
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return Future.value(false);
  }

  void _initialData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idSales = preferences.getString("idSales");
    customerController.getListCustomer(idSales!);
  }

  void _navigateToNewCustomer() async {
    int status =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FormNewCustomerView();
    }));
    _initialData();
    }
}
