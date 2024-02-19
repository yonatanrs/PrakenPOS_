
import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/models/RecapStock.dart';
import 'package:flutter_scs/models/Reconsile.dart';
import 'package:flutter_scs/view/reconsile/ReconsileView.dart';
import 'package:flutter_scs/view/stock/SummaryReconsileView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapStockView extends StatefulWidget {
  @override
  _RecapStockViewState createState() => _RecapStockViewState();
}

class _RecapStockViewState extends State<RecapStockView> {
  List<RecapStock> listStock = [];
  late String idSales;
  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorBlueDark,
            leading: BackButton(
              onPressed: onBackPress,
              color: colorAccent,
            ),
            title: Text(
              'Recapitulation Stock',
              style: textHeaderView,
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 85),
                    for (int index = 0; index < listStock.length; index++)
                      Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child:
                                            Text(listStock[index].nameProduct!)),
                                    SizedBox(width: 16),
                                    Expanded(
                                        flex: 2,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              listStock[index].qtyFisik =
                                                  int.parse(value);
                                              listStock[index].different =
                                                  listStock[index].qtyFisik! - listStock[index].qtySystem!;
                                            });
                                          },
                                        )),
                                  ]))),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: colorBlueDark,
                                )),
                            padding: EdgeInsets.all(8),
                            backgroundColor: colorBlueDark,
                          ),
                          child: Text(
                            'Proses',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          onPressed: () {
                            Reconsile model = new Reconsile();
                            model.note = '';
                            model.userBy = idSales;
                            model.listRecapStock = listStock;
                            Reconsile.insertReconsile(model).then((value) {
                              print('value :$value');
                              var code = value.codeError;
                              if (code == '400') {
                                Fluttertoast.showToast(
                                    msg: value.codeError!,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.redAccent.shade700,
                                    textColor: Colors.yellow,
                                    fontSize: 16);
                              } else {
                                insertTransaction(model.listRecapStock!);
                              }
                            });
                          }),
                    )
                  ],
                ),
              ),
              Container(
                height: 80,
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text('Name Product')),
                        SizedBox(width: 16),
                        Expanded(flex: 2, child: Text('Physical Stock')),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void insertTransaction(List<RecapStock> listRecapStock) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSales = preferences.getString("idSales");
    String? idDevice = preferences.getString("idDevice");
    String idMerger = idSales! + '_0000';
    int grandTotal = 0;
    List<Product> listProduct = <Product>[];
    for (int values = 0; values < listRecapStock.length; values++) {
      if (listRecapStock[values].different! < 0) {
        Product model = new Product();
        model.idProduct = listRecapStock[values].idProduct;
        model.nameProduct = listRecapStock[values].nameProduct;
        model.unit = listRecapStock[values].unitProduct;
        model.stock = listRecapStock[values].qtyFisik;
        model.price = listRecapStock[values].price;
        model.totalQty = listRecapStock[values].different! * -1;
        model.subTotal = model.price! * model.totalQty!;
        model.discount = 0;
        // model.subTotal = listCart[values].subTotal - listCart[values].discount;
        grandTotal = model.subTotal! + grandTotal;
        listProduct.add(model);
      }
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SummaryReconsileView(
          listProduct: listProduct,
          grandTotal: grandTotal,
          idMerger: idMerger,
          idDevice: idDevice!);
    }));
  }
   
  Future<bool> onBackPress() async{
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ReconsileView();
    }));
    return Future.value(false);
  }

  void getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idSales = preferences.getString("idSales")!;

    RecapStock.getListRecapStock(idSales).then((value) {
      setState(() {
        listStock = value!;
      });
    });
  }
}
