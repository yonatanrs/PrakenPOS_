import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/state_management/providers/CartStockProvider.dart';
import 'package:flutter_scs/view/ListPayment.dart';
import 'package:flutter_scs/view/ListProductView.dart';
import 'package:flutter_scs/view/transaction/MainTransactionView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
  final Customer model;
  final String? orderId;
  final bool isDraft;
  final String? codeName;

  CartView({required this.model, this.orderId, required this.isDraft, this.codeName});
}

class _CartViewState extends State<CartView> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController _discountController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _qtyController = new TextEditingController();
  int grandTotal = 0;
  late String nameCustomer;
  late List<Cart> _listCart;
  late int discount;
  late Cart carts;
  late String _valUnit;
  List<List<dynamic>> dataUnit = [];

  bool unitContains(String unit, int index) {
    List<dynamic> unitValues = dataUnit[index];
    for (int i = 0; i < unitValues.length; i++) {
      if (unit == unitValues[i]) {
        return true;
      }
    }
    return false;
  }

  void initState() {
    super.initState();
    listProductCart();
    getAllPriceUnit();
    getFromSharedPrefs();
  }

  late String role;
  getFromSharedPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString("getRole")!;
  }

  getPriceUnit(int index) async {
    var urlGetPriceUnit;
    var urlGetPriceDiscount;
    urlGetPriceUnit = ApiConstant().urlApi +
        "api/AllPrice?cust=${widget.codeName}&item=${_listCart[index].idProduct}&unit=${_listCart[index].unit}&qty=${_listCart[index].qty}";
    print("url get price unit: " + urlGetPriceUnit);
    urlGetPriceDiscount = ApiConstant().urlApi +
        "api/AllDiscount?cust=${widget.codeName}&item=${_listCart[index].idProduct}&unit=${_listCart[index].unit}&qty=${_listCart[index].qty}";
    final responsePriceUnit = await get(Uri.parse(urlGetPriceUnit));
    final responsePriceDiscount = await get(Uri.parse(urlGetPriceDiscount));
    var listDataPriceUnit = jsonDecode(responsePriceUnit.body);
    double listDataPriceDiscount = jsonDecode(responsePriceDiscount.body);
    print(urlGetPriceUnit);
    print(urlGetPriceDiscount);
    setState(() {
      double priceDouble = listDataPriceUnit;
      double priceDiscount = listDataPriceDiscount;
      _listCart[index].price = priceDouble.toInt();
      _listCart[index].discount = priceDiscount;
      double truncateToDecimalPlaces(num value, int fractionalDigits) =>
          (value * pow(10, fractionalDigits)).truncate() /
          pow(10, fractionalDigits);
      _listCart[index].discount = truncateToDecimalPlaces(priceDiscount, 2);
      print("tes ini discount hasil api : ${_listCart[index].discount}");
      _listCart[index].subTotal = _listCart[index].price! * _listCart[index].qty!;
      _listCart[index].total = _listCart[index].subTotal! *
          (100.0 - _listCart[index].discount) ~/
          100.0;
      grandTotal = 0;
      for (int value = 0; value < _listCart.length; value++) {
        grandTotal = _listCart[value].total! + grandTotal;
      }
      _discountController.text = _listCart[index].discount.toString();
      print("Data dataPriceUnit : $listDataPriceUnit");
      print("Data dataPriceDiscount : $listDataPriceDiscount");
    });
  }

  getAllPriceUnit() async {
    for (int value = 0; value < _listCart.length; value++) {
      getPriceUnit(value);
    }
  }

  getAllPriceTotal() async {
    grandTotal = 0;
    for (int value = 0; value < _listCart.length; value++) {
        _listCart[value].subTotal =
            _listCart[value].price! * _listCart[value].qty!;
        _listCart[value].total = _listCart[value].subTotal! *
            (100.0 - _listCart[value].discount) ~/
            100.0;
        grandTotal += _listCart[value].total!;
    }
  }

  void listProductCart() async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    var urlGetUnit;
    var listData;
    _listCart = list.map((e) => e as Cart).toList();
    for (int value = 0; value < _listCart.length; value++) {
      grandTotal = _listCart[value].subTotal! + grandTotal;
      urlGetUnit =
          "${ApiConstant().urlApi}api/Unit?item=${_listCart[value].idProduct}";
      print("url get unit: " + urlGetUnit);
      final response = await get(Uri.parse(urlGetUnit));
      listData = jsonDecode(response.body);
      dataUnit.add(listData);
      print(urlGetUnit);
    }
    setState(() {
      print("url get unit: " + urlGetUnit);
      for (int i = 0; i < _listCart.length; i++) {
        if (!unitContains(_listCart[i].unit!, i)) {
          if (dataUnit[i].isNotEmpty) {
            _listCart[i].unit = dataUnit[i][0];
          }
        }
      }
    });
    // refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () => _onBackPress(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorAccent,
            ),
            onPressed: _onBackPress,
          ),
          title: Text(
            "My Cart ${widget.codeName}",
            style:
                TextStyle(fontSize: ScreenUtil().setSp(20), color: colorAccent),
          ),
          actions: [
            role=="Canvas"?Container(
              margin: EdgeInsets.only( right: 20, top: 8,bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  nextStepTransaction(2);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: colorBlueSky,
                      )),
                  // padding: EdgeInsets.all(8),
                  backgroundColor: colorNetral,
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: Text(
                    "Send to AX",
                    style: TextStyle(
                        color: colorBlueDark,
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ):SizedBox(height: 0,),
          ],
        ),
        body: ChangeNotifierProvider<CartStockProvider>(
          create: (context) => CartStockProvider(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: _listCart == null
                      ? Center(
                          child: Text(
                            'No Data',
                            style: textHeaderView,
                          ),
                        )
                      : ListView(
                          children: <Widget>[
                            for (var index = 0;
                                index < _listCart.length;
                                index++)
                              cartItems(_listCart[index], index)
                          ],
                        )),
              _checkoutSection(grandTotal)
            ],
          ),
        ),
      ),
    );
  }

  void calculateSubTotal(
      Cart model,
      CartStockProvider provider,
      // int index,
      int typeOperation) async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    int position =
        listCart.indexWhere((element) => element.idProduct == model.idProduct);
    if (typeOperation == 0) {
      _cartBox.deleteAt(position);
      grandTotal -= model.total!;
    }
    // grandTotal = 0;
    for (int value = 0; value < _listCart.length; value++) {
      _listCart[value].subTotal =
          _listCart[value].price! * _listCart[value].qty!;
      _listCart[value].total = _listCart[value].subTotal! *
          (100.0 - _listCart[value].discount!) ~/
          100.0;
      print("cekuy :$grandTotal");
      grandTotal = grandTotal;
      for (int value = 0; value < _listCart.length; value++) {
        _listCart[value].subTotal =
            _listCart[value].price! * _listCart[value].qty!;
        _listCart[value].total = _listCart[value].subTotal! *
            (100.0 - _listCart[value].discount) ~/
            100.0;
        grandTotal = grandTotal;
      }
      Box _cartBox = await Hive.openBox("carts");
      Map<dynamic, dynamic> raw = _cartBox.toMap();
      List list = raw.values.toList();
      var urlGetUnit;
      var listData;
      _listCart = list.map((e) => e as Cart).toList();
      for (int value = 0; value < _listCart.length; value++) {
        urlGetUnit =
        "${ApiConstant().urlApi}api/Unit?item=${_listCart[value].idProduct}";
        print("url get unit: " + urlGetUnit);
        final response = await get(Uri.parse(urlGetUnit));
        listData = jsonDecode(response.body);
        dataUnit.add(listData);
        print(urlGetUnit);
      }
      setState(() {
        print("url get unit: " + urlGetUnit);
        for (int i = 0; i < _listCart.length; i++) {
          if (!unitContains(_listCart[i].unit!, i)) {
            if (dataUnit[i].isNotEmpty) {
              _listCart[i].unit = dataUnit[i][0];
            }
          }
        }
      });
    }
    // provider.setSubTotal();
  }

  Widget cartItems(Cart cart, int index) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(0)),
      margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
      height: ScreenUtil().setHeight(270),
      decoration: BoxDecoration(
        border: Border.all(color: colorBlueSky),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Consumer<CartStockProvider>(
          builder: (context, cartValue, _) => Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      cart.nameProduct! +
                          " (Stock : " +
                          cart.stock.toString() +
                          ")",
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: TextStyle(
                          color: colorBlueDark,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(15)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      calculateSubTotal(_listCart[index],cartValue, 0);
                      setState(() {
                        // listProductCart();
                      });
                      refreshController.requestRefresh();
                    },
                    tooltip: 'Hapus Produk',
                    color: Colors.redAccent[700],
                    icon: Icon(Icons.delete),
                    iconSize: ScreenUtil().setSp(20),
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8),
              ),
              Row(
                children: <Widget>[
                  Text("Harga : "),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            getPriceUnit(index);
                            getAllPriceTotal();
                          },
                          child: Icon(
                            Icons.refresh,
                            color: colorBlueDark,
                            size: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _priceController,
                                            cursorColor: colorBlueDark,
                                            textInputAction:
                                                TextInputAction.done,
                                            onChanged: (value) {
                                              setState(() {
                                                value = _priceController.text;
                                              });
                                              print("ini value price : $value");
                                            },
                                            initialValue: null,
                                            decoration: InputDecoration(
                                              hintText: 'Masukkan harga',
                                              labelText: 'RP',
                                              errorStyle: TextStyle(
                                                  color: colorError,
                                                  fontSize:
                                                      ScreenUtil().setSp(13)),
                                              hintStyle: TextStyle(
                                                  color: colorBlueDark,
                                                  fontSize:
                                                      ScreenUtil().setSp(15)),
                                              labelStyle: TextStyle(
                                                  color: colorBlueDark,
                                                  fontSize:
                                                      ScreenUtil().setSp(17)),
                                              // border: InputBorder.,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _listCart[index].price = int.parse(_priceController.text);
                                              _listCart[index].subTotal =
                                                  _listCart[index].price! *
                                                      _listCart[index].qty!;
                                              _listCart[index].total =
                                                  _listCart[index].subTotal! *
                                                      (100.0 -
                                                          _listCart[index]
                                                              .discount) ~/
                                                      100.0;
                                              grandTotal += _listCart[index].total!;
                                              getAllPriceTotal();
                                            });
                                          },
                                          child: Text('Ok'))
                                    ],
                                  );
                                });
                          },
                          child: Icon(
                            Icons.edit,
                            color: colorBlueDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ' +
                        MoneyFormatter(
                                amount: _listCart[index].price!.toDouble() ?? 0)
                            .output
                            .nonSymbol,
                    // amount: cart.price.toDouble()).output.nonSymbol,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),

              //subtotal
              Row(
                children: <Widget>[
                  Text("Sub Total"),
                  Spacer(),
                  Text(
                      'Rp ' +
                          MoneyFormatter(
                                  amount:
                                      _listCart[index].subTotal!.toDouble() ?? 0)
                              // amount: cart.subTotal.toDouble() ?? 0)
                              .output
                              .nonSymbol,
                      // amount: cart.subTotal.toDouble()).output.nonSymbol,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w300,
                        color: colorBlueDark,
                      )),
                ],
              ),

              //widget discount
              Container(
                child: Row(
                  children: <Widget>[
                    Text("Discount"),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              getPriceUnit(index);
                              getAllPriceTotal();
                            },
                            child: Icon(
                              Icons.refresh,
                              color: colorBlueDark,
                              size: 20,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showDialogDiscount(_listCart[index].subTotal!,
                                  _listCart[index].idProduct!, index);
                            },
                            child: Icon(
                              Icons.edit,
                              color: colorBlueDark,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                        // _discountController.text,
                        "${_listCart[index].discount}",
                        // "${discountConvert}",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w300,
                          color: colorBlueDark,
                        )),
                  ],
                ),
              ),

              Row(
                children: <Widget>[
                  Text("Total : "),
                  Spacer(),
                  // cartValue.getProduct.toString() == null
                  Text(

                      'Rp ' +
                          MoneyFormatter(
                                  amount: _listCart[index].total!.toDouble())
                              .output
                              .nonSymbol,
                      // amount: cart.total.toDouble()).output.nonSymbol,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w700,
                        color: colorBlueDark,
                      )),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Qty",
                    style: TextStyle(
                        color: colorBlueDark,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // cartValue.setQty(1, cart);
                          setState(() {
                            _listCart[index].qty! -1;
                            if (_listCart[index].qty! < 1) {
                              _listCart[index].qty = 1;
                            }
                            getPriceUnit(index);
                            getAllPriceTotal();
                          });
                        },
                        // onTap: () => cartValue.setQty(1, cart),
                        splashColor: Colors.redAccent[400],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setSp(6)),
                              child: SvgPicture.asset(
                                'lib/assets/icons/Minus.svg',
                                color: Colors.red,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          //qty dialog
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _qtyController,
                                          cursorColor: colorBlueDark,
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) {
                                            setState(() {
                                              value = _qtyController.text;
                                            });
                                            print("ini value qty : $value");
                                          },
                                          initialValue: null,
                                          decoration: InputDecoration(
                                            hintText: 'Masukkan quantity',
                                            labelText: 'qty',
                                            errorStyle: TextStyle(
                                                color: colorError,
                                                fontSize:
                                                    ScreenUtil().setSp(13)),
                                            hintStyle: TextStyle(
                                                color: colorBlueDark,
                                                fontSize:
                                                    ScreenUtil().setSp(15)),
                                            labelStyle: TextStyle(
                                                color: colorBlueDark,
                                                fontSize:
                                                    ScreenUtil().setSp(17)),
                                            // border: InputBorder.,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          _listCart[index].qty =
                                              int.parse(_qtyController.text);
                                          getPriceUnit(index);
                                          getAllPriceTotal();
                                        },
                                        child: Text('Ok'))
                                  ],
                                );
                              });
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(_listCart[index].qty.toString()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _listCart[index].qty! +1;
                            getPriceUnit(index);
                            _listCart[index].price;
                            getAllPriceTotal();
                            getPriceUnit(index);
                          });
                        },
                        splashColor: Colors.lightBlue,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(
                                'lib/assets/icons/Plus.svg',
                                color: Colors.green,
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Unit",
                    style: TextStyle(
                        color: colorBlueDark,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Flexible(
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Item is empty please select!!';
                        }
                        return null;
                      },
                      value: cart.unit ?? "",
                      items: dataUnit[index].map((item) {
                        return DropdownMenuItem<String>(
                          child: Text(item ?? "Loading"),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          cart.unit = newValue;
                          getPriceUnit(index);
                          getAllPriceTotal();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: cartValue.getProduct != null
                        ? Text(
                            cartValue.getProduct.message!,
                            style: TextStyle(
                                color: colorError,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(cart.message ?? '',
                            style: TextStyle(
                                color: colorError,
                                fontSize: 15,
                                fontWeight: FontWeight.bold))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _checkoutSection(int grandTotal) {
    return Container(
      decoration: BoxDecoration(
        color: colorBlueDark,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Consumer<CartStockProvider>(
        builder: (context, cartValue, _) => Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(10),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10)),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Grand Total :",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: colorNetral,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Text(
                        "Rp " +
                            MoneyFormatter(amount: grandTotal.toDouble())
                                .output
                                .nonSymbol,
                        // amount: grandTotal.toDouble()).output.nonSymbol,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: colorNetral,
                            fontWeight: FontWeight.w500))
                  ],
                )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () => _showAlertDialog(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: colorBlueSky,
                            )),
                        padding: EdgeInsets.all(8),
                        backgroundColor: colorNetral,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                        child: Text(
                          "BAYAR",
                          style: TextStyle(
                              color: colorBlueDark,
                              fontSize: ScreenUtil().setSp(13),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () => nextStepTransaction(0),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: colorBlueSky,
                            )),
                        padding: EdgeInsets.all(8),
                        backgroundColor: colorNetral,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                        child: Text(
                          "SIMPAN PESANAN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: colorBlueDark,
                              fontSize: ScreenUtil().setSp(13),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Informasi !!!'),
            content: Text(
              'Apakah sudah yakin dengan produk ini ? Jika sudah yakin tekan YA tapi Anda tidak bisa kembali untuk memilih produk.',
              style: TextStyle(fontSize: 12, color: colorBlueDark),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tidak')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    nextStepTransaction(1);
                  },
                  child: Text('Ya'))
            ],
          );
        });
  }

  void _showDialogDiscount(int subtotal, String idProduct, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _discountController,
                    cursorColor: colorBlueDark,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: null,
                    decoration: InputDecoration(
                      hintText: 'Masukkan promo',
                      labelText: 'Masukkan besaran promo(%)',
                      errorStyle: TextStyle(
                          color: colorError, fontSize: ScreenUtil().setSp(13)),
                      hintStyle: TextStyle(
                          color: colorBlueDark,
                          fontSize: ScreenUtil().setSp(15)),
                      labelStyle: TextStyle(
                          color: colorBlueDark,
                          fontSize: ScreenUtil().setSp(17)),
                      // border: InputBorder.,
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Text("Discount (Rp) : "),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        _listCart[index].discount == 0
                            ? Text(
                                'Rp ' +
                                    MoneyFormatter(
                                            amount: double.parse(_listCart[index].discount.toString()))
                                        .output
                                        .nonSymbol,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w300,
                                  color: colorBlueDark,
                                ))
                            : Text(
                                'Rp ' +
                                    MoneyFormatter(
                                            // amount: double.parse(_discountController.text)).output.nonSymbol,
                                            amount: _listCart[index].discount)
                                        .output
                                        .nonSymbol,
                                // amount: cartValue.getDiscount.toDouble()).output.nonSymbol,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w300,
                                  color: colorBlueDark,
                                )),
                      ],
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Text("Total : "),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        _listCart[index].total == 0
                            ? Text(
                                'Rp ' +
                                    MoneyFormatter(
                                            amount: _listCart[index]
                                                .subTotal
                                                !.toDouble())
                                        .output
                                        .nonSymbol,
                                // amount: subtotal.toDouble()).output.nonSymbol,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w300,
                                  color: colorBlueDark,
                                ))
                            : Text(
                                'Rp ' +
                                    MoneyFormatter(
                                            amount: _listCart[index]
                                                .subTotal
                                                !.toDouble())
                                        .output
                                        .nonSymbol,
                                // amount: cartValue.getTotal.toDouble()).output.nonSymbol,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w300,
                                  color: colorBlueDark,
                                )),
                      ],
                    )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _listCart[index].discount = double.parse(_discountController.text);
                      // _listCart[index].subTotal = _listCart[index].price * _listCart[index].qty;
                      _listCart[index].total = _listCart[index].subTotal! * (_listCart[index].discount) ~/ 100.0;
                      print("ini listCartTotal pengurangan harga diskon: ${_listCart[index].total}");
                      print("ini grandTotal discount: $grandTotal");
                      // grandTotal += _listCart[index].total;
                      getAllPriceTotal();
                    });
                  },
                  // },
                  child: Text('Ok'))
            ],
          );
        });
  }

  Future<bool> _onBackPress() async {
    if (widget.isDraft) {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MainTransactionView(indexTab: 1);
      }));
      return false; // Assuming you do not want to pop the current route again
    } else {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ListProductView(
          customer: widget.model,
          codeCustomer: widget.codeName!,
        );
      }));
      return false; // Assuming you do not want to pop the current route again
    }
  }

  void deleteCart() async {
  }

  void nextStepTransaction(int condition) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSales = preferences.getString("idSales");
    String? idDevice = preferences.getString("idDevice");
    String idMerger = idSales! + '_' + widget.model.codeCust.toString();

    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    List<Product> listProduct = <Product>[];
    int grandTotal = 0;
    for (int values = 0; values < listCart.length; values++) {
      Product model = new Product();
      model.idProduct = listCart[values].idProduct;
      model.nameProduct = listCart[values].nameProduct;
      model.unit = listCart[values].unit;
      model.stock = listCart[values].stock;
      model.price = listCart[values].price;
      model.totalQty = listCart[values].qty;
      model.subTotal = listCart[values].subTotal;
      model.discount = listCart[values].discount.toInt();
      // model.subTotal = listCart[values].subTotal - listCart[values].discount;
      grandTotal = listCart[values].total! + grandTotal;
      listProduct.add(model);
    }
    Product.insertTransaction(listProduct, idMerger, grandTotal, idDevice!,
            widget.orderId!, condition)
        .then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              if (condition == 1) {
                List<String> result = value.split('_');
                if (result[0] != "Failed") {
                  return ListPayment(
                    amount: result[1],
                    idOrder: result[0],

                  );
                } else {
                  Fluttertoast.showToast(
                      msg: 'Failed for Insert Transaction',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.redAccent.shade700,
                      textColor: Colors.yellow,
                      fontSize: ScreenUtil().setSp(16));
                }
              } else {
                deleteCart();
                return MainTransactionView(indexTab: 1);
              }
              return WidgetStateLoading();
            })));
  }
}
