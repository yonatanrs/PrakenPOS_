import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/ListPayment.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_formatter/money_formatter.dart';

class SummaryReconsileView extends StatefulWidget {
  @override
  _SummaryReconsileViewState createState() => _SummaryReconsileViewState();
  final List<Product> listProduct;
  final String idMerger;
  final int grandTotal;
  final String idDevice;
  SummaryReconsileView(
      {required this.listProduct, required this.idMerger, required this.grandTotal, required this.idDevice});
}

class _SummaryReconsileViewState extends State<SummaryReconsileView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: colorBlueDark,
              automaticallyImplyLeading: false,
              leading: BackButton(
                onPressed: onBackPress,
                color: colorAccent,
              ),
              title: Text('Summary Reconsile', style: textHeaderView),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 85),
                      for (int index = 0;
                          index < widget.listProduct.length;
                          index++)
                        Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.listProduct[index]
                                                  .nameProduct!),
                                              SizedBox(height: 10),
                                              Text(widget.listProduct[index]
                                                      .totalQty
                                                      .toString() +
                                                  ' ' +
                                                  widget
                                                      .listProduct[index].unit!)
                                            ],
                                          )),
                                      SizedBox(width: 16),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Rp ' +
                                                MoneyFormatter(
                                                        amount: widget.listProduct[index].subTotal!.toDouble())
                                                    .output
                                                    .nonSymbol,
                                            textAlign: TextAlign.center,
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
                              'Proses (Total : ${'Rp ' + MoneyFormatter(amount: widget.grandTotal.toDouble()).output.nonSymbol})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            onPressed: () {
                              Product.insertTransaction(
                                      widget.listProduct,
                                      widget.idMerger,
                                      widget.grandTotal,
                                      widget.idDevice,
                                      "", 1)
                                  .then((value) =>
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        List<String> result = value.split('_');
                                        if (result[0] != "Failed") {
                                          return ListPayment(
                                            amount: result[1],
                                            idOrder: result[0],
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Failed for Insert Transaction',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor:
                                                  Colors.redAccent.shade700,
                                              textColor: Colors.yellow,
                                              fontSize: 16);
                                        }

                                        return SizedBox();
                                      })));
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name Product'),
                                  SizedBox(height: 10),
                                  Text('Qty')
                                ],
                              )),
                          SizedBox(width: 16),
                          Align(
                              alignment: Alignment.topRight,
                              child: Expanded(flex: 2, child: Text('Subtotal')))
                        ]),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future onBackPress() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
  }
}
