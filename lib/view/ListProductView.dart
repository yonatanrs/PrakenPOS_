import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardProductAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/state_management/providers/CartProvider.dart';
import 'package:flutter_scs/view/CartView.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/ListCustomerView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ListProductView extends StatefulWidget {
  @override
  _ListProductViewState createState() => _ListProductViewState();
  final Customer? customer;
  final String? codeCustomer;

  ListProductView({this.customer, this.codeCustomer});
}

class _ListProductViewState extends State<ListProductView>
    with SingleTickerProviderStateMixin {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final _debouncer = Debounce(miliseconds: 10);
  TextEditingController filterController = new TextEditingController();

  int countProduct = 0;
  String? idSales;
  String? idDevice;
  List<Product>? listProductsReal;
  List<Product>? _listProduct;
  int qty = 0;
  Box? _cartBox;

  int subTotal = 0;
  String? nameCustomer;
  List<Cart>? _listCart;
  int condition = 1;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  Future<Null> listProduct() async {
    await Future.delayed(Duration(seconds: 5));
    Product.getProduct(idSales!, widget.customer!.codeCust!, condition).then((value) {
      setState(() {
        listProductsReal = value;
        _listProduct = listProductsReal;
      });
    });
    return null;
  }

  Future<void> listProductCart() async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    qty = 0;
    subTotal = 0;
    setState(() {
      _listCart = list.map((e) => e as Cart).toList();
      for (int value = 0; value < _listCart!.length; value++) {
        subTotal = _listCart![value].subTotal! + subTotal;
        qty = _listCart![value].qty! + qty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        StreamProvider<int>(
          initialData: 0,
          create: (BuildContext context) =>
              Stream.periodic(Duration(milliseconds: 1000), (i) => i),
        ),
        ChangeNotifierProvider<CartProvider>.value(value: CartProvider())
      ],
      child: WillPopScope(
          onWillPop: _onBackPress,
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: colorBlueDark,
                  title: Text(
                    'Daftar Produk ${widget.codeCustomer}',
                    style: textHeaderView,
                  ),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: colorAccent,
                      onPressed: () {
                        _onBackPress();
                      })),
              backgroundColor: colorNetral,
              bottomNavigationBar: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          topLeft: Radius.circular(18)),
                      color: colorBlueDark),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<CartProvider>(
                          builder: (context, cartValue, _) =>
                              cartValue.getCountProduct == 0
                                  ? Text(
                                      'Total Item : ' + qty.toString(),
                                      style: TextStyle(
                                          color: colorAccent, fontSize: 17),
                                    )
                                  : Text(
                                      'Total Item : ' +
                                          cartValue.getCountProduct.toString(),
                                      style: TextStyle(
                                          color: colorAccent, fontSize: 17))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: colorBlueDark,
                                )),
                            backgroundColor: colorNetral,
                          ),
                          child: Row(children: [
                            Text('Cart'),
                            SvgPicture.asset(
                              'lib/assets/icons/Chevron_right.svg',
                              color: colorBlueDark,
                            )
                          ]),
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return CartView(
                                  model: widget.customer!, isDraft: false, codeName: widget.codeCustomer,);
                            }));
                          })
                    ],
                  )),
              body: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Consumer<CartProvider>(
                      builder: (context, cartValue, _) => TextField(
                        controller: filterController,
                        // onTap: () {
                        //   // cartValue.setRefreshCart();
                        //   // setState(() {
                        //   //   qty = cartValue.getCountProduct;
                        //   // });
                        // },
                        onChanged: (String value){
                          _listProduct = listProductsReal
                              !.where((element) => element
                              .nameProduct
                              !.toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                          setState(() {
                            value = _listProduct as String;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.all(ScreenUtil().setHeight(10)),
                            hintText: 'Search by Product',
                            suffixIcon: IconButton(
                                icon:
                                    Icon(Icons.search, color: colorBackground),
                                onPressed: () {
                                  String value = filterController.text;
                                  cartValue.setRefreshCart();
                                  // setState(() {
                                    qty = cartValue.getCountProduct;
                                  // });
                                  _debouncer.run(() {
                                    setState(() {
                                      _listProduct = listProductsReal
                                          !.where((element) => element
                                              .nameProduct
                                              !.toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  });
                                })),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        SmartRefresher(
                          controller: refreshController,
                          onRefresh: listProduct,
                          child: FutureBuilder(
                              future: Product.getProduct(
                                  idSales!, widget.customer!.codeCust!, condition),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError != true) {
                                    _listProduct == null
                                        ? _listProduct =
                                            listProductsReal = snapshot.data
                                        : _listProduct = _listProduct;
                                    if (_listProduct!.length == 0) {
                                      return Center(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'No Data',
                                              style: textError,
                                            ),
                                            TextButton.icon(
                                                onPressed: () => listProduct(),
                                                icon: Icon(
                                                  Icons.refresh,
                                                  color: colorBlueDark,
                                                ),
                                                label: Text(
                                                  'Click for Refresh',
                                                  style: textButton,
                                                ))
                                          ],
                                        ),
                                      );
                                    }
                                    return StaggeredGridView.countBuilder(
                                      crossAxisCount: 4,
                                      primary: false,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      itemCount: _listProduct!.length,
                                      itemBuilder: (context, index) =>
                                          CardProductAdapter(
                                            models: _listProduct![index],
                                          ),
                                      staggeredTileBuilder: (index) =>
                                          StaggeredTile.fit(2),
                                    );
                                  } else {
                                    print(snapshot.error.toString());
                                  }
                                }
                                // else {
                                //   return WidgetStateLoading();
                                // }
                                return Container();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  Future<bool> _onBackPress() async {
    Box _cartBox = await Hive.openBox("carts");
    // exit(0);
    if (_cartBox.length > 1) {
      deleteCart();
      _navigateBack();
    } else {
      _navigateBack();
    }
    return true;
  }

  _navigateBack() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return ListCustomerView();
    }));
  }

  void getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idDevice = preferences.getString("idDevice");
      idSales = preferences.getString("idSales");
    });
    _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox!.toMap();
    List list = raw.values.toList();
    List<Cart> _listCart = list.map((e) => e as Cart).toList();
    for (int value = 0; value < _listCart.length; value++) {
      setState(() {
        qty = _listCart[value].qty! + qty;
      });
    }
    print("madafaka : ${widget.customer!.codeCust!}");
    Product.getProduct(idSales!, widget.customer!.codeCust!, condition).then((value) {
      setState(() {
        listProductsReal = value;
        _listProduct = listProductsReal;
      });
    });
  }

  void deleteCart() async {
    _cartBox!.deleteFromDisk();
  }
}
