import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/widgets/AlertLoading.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';
import 'package:flutter_scs/state_management/providers/PriceDiscountProvider.dart';
import 'package:flutter_scs/view/priceDiscount/PriceDiscountView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDiscountView extends StatefulWidget {
  @override
  _FormDiscountViewState createState() => _FormDiscountViewState();
}

class _FormDiscountViewState extends State<FormDiscountView> {
  late FocusNode _fromDateFocus, _endDateFocus = new FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey keyDropdown = GlobalKey();
  late Customer _selectedCustomer;
  late Product _selectedProduct;
  late String _selectedUnit;
  late List<DropdownMenuItem<Customer>> _dropdownCustomer;
  late List<DropdownMenuItem<Product>> _dropdownProduct;
  late List<DropdownMenuItem<String>> _dropdownUnit;
  late List<Customer> listCustomer;
  late List<Product> listProduct;
  late List<String> listUnit;
  late String _idCustomer, _groupCustomer, _idProduct, _groupProduct;
  late DateTime _fromDate, _endDate;
  late int price, _disc1, _disc2;
  late String token, username, idSales;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getCustomer() {
    Customer.getCustomer(idSales, 2).then((value) {
      _dropdownCustomer = [];
      listCustomer = value;
      buildDropdownCustomer(value);
    });
  }

  void getProduct() {
    Product.getAllProduct(token, username, idSales).then((onValue) {
      _dropdownProduct = [];
      listProduct = onValue;
      buildDropdownProduct(onValue);
    });
  }

  void buildDropdownCustomer(List customers) {
    for (Customer customer in customers) {
      setState(() {
        _dropdownCustomer.add(
          DropdownMenuItem(
            value: customer,
            child: Text(customer.nameCust!),
          ),
        );
      });
    }
  }

  void buildDropdownProduct(List products) {
    for (Product product in products) {
      setState(() {
        _dropdownProduct.add(
          DropdownMenuItem(
            value: product,
            child: Text(product.nameProduct!),
          ),
        );
      });
    }
  }

  void buildDropdownUnit(List units) {
    for (String unit in units) {
      setState(() {
        _dropdownUnit.add(
          DropdownMenuItem(
            value: unit,
            child: Text(unit),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //     BoxConstraints(
    //       maxWidth: MediaQuery.of(context).size.width,
    //       maxHeight: MediaQuery.of(context).size.height,
    //     )
    // );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          title: Text('Form Price and Discount New Customer'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: colorAccent,
            onPressed: () => _onBackPress(),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  PriceDiscount models = new PriceDiscount();
                  models.idCustomer = _idCustomer;
                  models.customer = _groupCustomer;
                  models.idProduct = _idProduct;
                  models.product = _groupProduct;
                  models.price = price.toString();
                  models.unit = _selectedUnit;
                  models.fromDate =
                      DateFormat('MM-dd-yyyy').format(_fromDate).toString();
                  models.endDate =
                      DateFormat('MM-dd-yyyy').format(_endDate).toString();
                  models.disc1 = _disc1;
                  models.disc2 = _disc2;
                  PriceDiscount.insertDiscount(models).then((value) {
                    if (value != "Success") {
                      Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.green[400],
                          textColor: Colors.black,
                          fontSize: ScreenUtil().setSp(16));
                    } else {
                      AlertLoading().alertLoading(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return PriceDiscountView();
                      }));
                    }
                  });
                },
                child: Text(
                  'Submit',
                  style: textButton,
                ))
          ],
        ),
        body: ChangeNotifierProvider<PriceDiscountProvider>(
          create: (context) => PriceDiscountProvider(),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //customer
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(7),
                          ScreenUtil().setWidth(7),
                          ScreenUtil().setWidth(0),
                          ScreenUtil().setWidth(5)),
                      child: Text(
                        "Customer ",
                        style: textDescription,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: Consumer<PriceDiscountProvider>(
                        builder: (context, discount, _) =>
                            DropdownButton<Customer>(
                                key: keyDropdown,
                                isExpanded: true,
                                hint: Text('-- Choose One --'),
                                value: _selectedCustomer,
                                items: _dropdownCustomer,
                                style: textDescription,
                                onChanged: (value) {
                                  discount.setGroupCustomer(
                                      listCustomer, value!.codeCust!);
                                  setState(() {
                                    _selectedCustomer = value;
                                    _idCustomer = value.codeCust!;
                                    _groupCustomer =
                                        discount.getGroupCustomer.toString();
                                  });
                                }),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(7),
                          ScreenUtil().setWidth(7),
                          ScreenUtil().setWidth(5),
                          ScreenUtil().setWidth(5)),
                      child: Consumer<PriceDiscountProvider>(
                        builder: (context, discount, _) => Text(
                            "Group Customer : " +
                                discount.getGroupCustomer.toString(),
                            style: textDescription),
                      ),
                    ),

                    //product
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: Text(
                        "Product ",
                        style: textDescription,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: Consumer<PriceDiscountProvider>(
                        builder: (context, discount, _) =>
                            DropdownButton<Product>(
                                isExpanded: true,
                                hint: Text('-- Choose One --'),
                                value: _selectedProduct,
                                items: _dropdownProduct,
                                style: textDescription,
                                onChanged: (value) {
                                  discount.setGroupProduct(
                                      listProduct, value!.idProduct!);
                                  setState(() {
                                    _selectedProduct = value;
                                    _idProduct = value.idProduct!;
                                    _groupProduct =
                                        discount.getGroupProduct.toString();
                                  });
                                }),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: Consumer<PriceDiscountProvider>(
                        builder: (context, discount, _) => Text(
                          "Group Product : " +
                              discount.getGroupProduct.toString(),
                          style: textDescription,
                        ),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: Text(
                        "Unit ",
                        style: textDescription,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8),
                          ScreenUtil().setWidth(8)),
                      child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('-- Choose One --'),
                          value: _selectedUnit,
                          items: _dropdownUnit,
                          style: textDescription,
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value!;
                            });
                          }),
                    ),

                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, fill this field';
                          }
                          price = int.parse(value);
                          return null;
                        },
                        onChanged: (value) {
                          price = int.parse(value);
                        },
                        style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                        cursorColor: colorBlueDark,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Price',
                            hintStyle: textDescription,
                            errorStyle: TextStyle(
                              color: colorError,
                            )),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, fill this field';
                          }
                          _disc1 = int.parse(value);
                          return null;
                        },
                        onChanged: (value) {
                          _disc1 = int.parse(value);
                        },
                        style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                        cursorColor: colorBlueDark,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Disc 1 *',
                            hintStyle: textDescription,
                            errorStyle: TextStyle(
                              color: colorError,
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, fill this field';
                          }
                          _disc2 = int.parse(value);
                          return null;
                        },
                        onChanged: (value) {
                          _disc2 = int.parse(value);
                        },
                        style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                        cursorColor: colorBlueDark,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Disc 2 *',
                            hintStyle: textDescription,
                            errorStyle: TextStyle(
                              color: colorError,
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                      child: DateTimeField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please, fill this field';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'From Date*',
                            hintStyle: textDescription,
                            errorStyle: TextStyle(
                              color: colorError,
                            )),
                        format: DateFormat('dd-MMM-yyyy'),
                        textInputAction: TextInputAction.next,
                        focusNode: _fromDateFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _fromDateFocus, _endDateFocus);
                        },
                        onChanged: (value) {
                          setState(() {
                            _fromDate = value!;
                          });
                        },
                        onShowPicker: (context, currentValue) async {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 2),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                            builder: (BuildContext context, child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                      child: DateTimeField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please, fill this field';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'End Date*',
                            hintStyle: textDescription,
                            errorStyle: TextStyle(
                              color: colorError,
                            )),
                        format: DateFormat('dd-MMM-yyyy'),
                        // textInputAction: TextInputAction.next,
                        focusNode: _fromDateFocus,
                        // onFieldSubmitted: (term) {
                        //   _fieldFocusChange(
                        //       context, _fromDateFocus, _endDateFocus);
                        // },
                        onChanged: (value) {
                          setState(() {
                            _endDate = value!;
                          });
                        },
                        onShowPicker: (context, currentValue) async {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 2),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                            builder: (BuildContext context, child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    Navigator.pop(context);
    return true;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    _formKey.currentState?.save();
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    idSales = preferences.getString("idSales")!;
    username = preferences.getString("username")!;
    getCustomer();
    getProduct();
    Product.getAllUnit().then((onValue) {
      _dropdownUnit = [];
      listUnit = onValue;
      buildDropdownUnit(onValue);
    });
  }
}
