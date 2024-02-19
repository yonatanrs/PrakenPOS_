import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockView extends StatefulWidget {
  @override
  _StockViewState createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = TextEditingController();
  List<Product> listProductReal = [];
  List<Product> _listProduct = [];
  bool isSearching = false;
  int condition = 1;
  String idCustomer = '', idSales = '';

  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  Future<void> listProduct() async {
    var listResult = await Product.getProduct(idSales, '', condition);
    setState(() {
      listProductReal = listResult ?? [];
      _listProduct = listProductReal;
    });
  }

  Future<List<Product>> getListProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idSales = preferences.getString("idSales") ?? '';
    var list = await Product.getProduct(idSales, '', condition);
    return list ?? [];
  }

  void setPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idSales = preferences.getString("idSales") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: onBackPressLines,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          leading: BackButton(
            onPressed: onBackPressLines,
            color: colorAccent,
          ),
          title: Text(
            'Stock Product',
            style: textHeaderView,
          ),
        ),
        body: Column(
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
                              .where((element) =>
                          element.nameProduct?.toLowerCase().contains(value.toLowerCase()) ?? false)
                              .toList();

                        });
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: getListProduct(),
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError != true) {
                      _listProduct = snapshot.data ?? [];
                      if (_listProduct.isEmpty) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'No Data',
                                style: textDescription,
                              ),
                              Text(
                                'Swipe down for refresh item',
                                style: textDescription,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: _listProduct.length,
                        itemBuilder: (BuildContext context, int index) =>
                            cardStockProduct(_listProduct[index]),
                      );
                    } else {
                      print(snapshot.error.toString());
                    }
                    return WidgetStateLoading();
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'No Data',
                            style: textDescription,
                          ),
                          Text(
                            'Swipe down for refresh item',
                            style: textDescription,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return WidgetStateLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardStockProduct(Product models) {
    return Card(
      shadowColor: colorBlueDark,
      elevation: 3,
      child: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      models.nameProduct ?? '',
                      style: textHeaderCard,
                    ),
                    SizedBox(height: 10),
                    Text('Unit : ${models.unit ?? ''}'),
                    SizedBox(height: 10),
                    Text('Stock : ${models.stock ?? ''}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressLines() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return false; // This prevents the back navigation from happening twice
  }
}
