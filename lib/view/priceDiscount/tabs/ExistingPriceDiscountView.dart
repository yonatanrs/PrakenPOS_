import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/CardExistingProductAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExistingPriceDiscountView extends StatefulWidget {
  @override
  _ExistingPriceDiscountViewState createState() =>
      _ExistingPriceDiscountViewState();
}

class _ExistingPriceDiscountViewState extends State<ExistingPriceDiscountView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  List<Product>? listProductReal;
  List<Product>? _listProduct;
  bool isSearching = false;
  int condition = 1;
  late String idCustomer, idSales;

  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  Future<Null> listProduct() async {
    var listResult = await Product.getProduct(idSales, '', condition);
    setState(() {
      listProductReal = listResult;
      _listProduct = listProductReal;
    });
    return null;
  }

  Future<List<Product>?> getListProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idSales = preferences.getString("idSales")!;
    var list = await Product.getProduct(idSales, '', condition);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: TextField(
            controller: filterController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Search by Product',
                suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: colorBackground),
                    onPressed: () {
                      String value = filterController.text;
                      _debouncer.run(() {
                        setState(() {
                          _listProduct = listProductReal
                              ?.where((element) => element.nameProduct!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      });
                    })),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>?>(
            future: getListProduct(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasError) {
                  _listProduct =
                      _listProduct ?? (listProductReal = snapshot.data);
                  if (_listProduct?.isEmpty ?? true) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text('No Data', style: textDescription),
                          Text('Swipe down for refresh item',
                              style: textDescription),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: _listProduct!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CardExistingProductAdapter(
                            models: _listProduct![index]),
                  );
                } else {
                  return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: textDescription),
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text('No Data', style: textDescription),
                      Text('Swipe down for refresh item',
                          style: textDescription),
                    ],
                  ),
                );
              } else {
                return WidgetStateLoading(); // Loading widget
              }
            },
          ),
        ),
      ],
    );
  }

  void setPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idSales = preferences.getString("idSales")!;
  }
}
