import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:hive/hive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardAllProductAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/MainMenuView.dart';

class AllProductView extends StatefulWidget {
  @override
  _AllProductViewState createState() => _AllProductViewState();
}

class _AllProductViewState extends State<AllProductView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  late List<Product> listProductsReal;
  late List<Product> _listProduct;
  bool isSearching = false;
  late Box _productBox;
  @override
  void initState() {
    super.initState();
    getAllProduct();
  }

  Future<Null> listProduct() async {
    await Future.delayed(Duration(seconds: 2));
    Map<dynamic, dynamic> raw = _productBox.toMap();
    List list = raw.values.toList();
    setState(() {
      listProductsReal = list.map((e) => e as Product).toList();
      _listProduct = listProductsReal;
    });
    return null;
  }

  Future<List<Product>> getListProduct() async {
    await Future.delayed(Duration(seconds: 2));
    Map<dynamic, dynamic> raw = _productBox.toMap();
    List list = raw.values.toList();
    return list.map((e) => e as Product).toList();
  }


  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          title: Text(
            'Daftar Product',
            style: textHeaderView,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: colorAccent,
            onPressed: () => _onBackPress(),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: TextField(
                controller: filterController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                    hintText: 'Search by Name or brand',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: colorBackground),
                        onPressed: () {
                          String value = filterController.text;
                          _debouncer.run(() {
                            setState(() {
                              _listProduct = listProductsReal
                                  .where((element) =>
                                      element.nameProduct
                                          !.toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.brand
                                          !.toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            });
                          });
                        })),
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: listProduct,
              child: FutureBuilder(
                  future: getListProduct(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError != true) {
                        // print("ini banyaknya item di list : ${_listProduct.length}");
                        _listProduct == null
                            ? _listProduct = listProductsReal = snapshot.data
                            : _listProduct = _listProduct;
                        if (_listProduct.length == 0) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'No Data',
                                  style: textHeaderView,
                                ),
                                Text(
                                  'Swipe down for refresh item',
                                  style: textHeaderView,
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                            itemCount: _listProduct.length,
                            itemBuilder: (BuildContext context, int index) =>
                                CardAllProductAdapter(
                                  models: _listProduct[index],
                                ));
                      } else {
                        print(snapshot.error.toString());
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'No Data',
                              style: textHeaderView,
                            ),
                            Text(
                              'Swipe down for refresh item',
                              style: textHeaderView,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return WidgetStateLoading();
                    }
                    return Container();
                  }),
            ))
          ],
        ),
      ),
    );
  }

  // void searchProduct(){
  //   setState(() {
  //     _listProduct = listProductsReal
  //         .where((element) =>
  //     element.nameProduct
  //         .toLowerCase()
  //         .contains(value.toLowerCase()) ||
  //         element.brand
  //             .toLowerCase()
  //             .contains(value.toLowerCase()))
  //         .toList();
  //   });
  // }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }

  void getAllProduct() async {
    _productBox = await Hive.openBox('products');
  }
}
