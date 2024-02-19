import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/DraftTransaction.dart';
import 'package:flutter_scs/view/CartView.dart';
import 'package:flutter_scs/view/slip/PackingSlipGenerate.dart';
import 'package:hive/hive.dart';
import 'package:flutter_scs/view/ListPayment.dart';

class BottomSheetAction extends StatefulWidget {
  final BuildContext context;
  final TransactionDraft transactionDraft;
  BottomSheetAction({required this.context, required this.transactionDraft});

  @override
  _BottomSheetActionState createState() => _BottomSheetActionState();
}

class _BottomSheetActionState extends State<BottomSheetAction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More Action',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close_rounded))
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: colorBlueDark,
                            )),
                        padding: EdgeInsets.all(8),
                        backgroundColor: colorNetral,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return ListPayment(
                            amount: widget.transactionDraft.totalAmount!,
                            idOrder: widget.transactionDraft.idOrder!,
                          );
                        }));
                      },
                      child: Text(
                        'PROSES BAYAR',
                        style: TextStyle(color: colorBackground, fontSize: 13),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: colorBlueDark,
                            )),
                        padding: EdgeInsets.all(8),
                        backgroundColor: colorNetral,
                      ),
                      onPressed: () {
                        insertToCart(
                            widget.transactionDraft.listDetailTransaction!);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CartView(
                            orderId: widget.transactionDraft.idOrder!,
                            model: Customer(
                                codeCust: widget.transactionDraft.idCustomer),
                            isDraft: true,
                          );
                        }));
                      },
                      child: Text(
                        'UPDATE BARANG',
                        style: TextStyle(color: colorBackground, fontSize: 13),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: colorBlueDark,
                            )),
                        padding: EdgeInsets.all(8),
                        backgroundColor: colorNetral,
                      ),
                      onPressed: () {
                        PackingSlipGenerate()
                            .CreatePdf(context, widget.transactionDraft, 0);
                      },
                      child: Text(
                        'LIHAT PACKING SLIP',
                        style: TextStyle(color: colorBackground, fontSize: 13),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> insertToCart(List<ListDetailTransaction> listDetail) async {
    Box _cartBox = await Hive.openBox("carts");
    for (int index = 0; index < listDetail.length; index++) {
      Cart cartModel = new Cart();
      cartModel.idProduct = listDetail[index].idProduct;
      cartModel.nameProduct = listDetail[index].nameProduct;
      cartModel.stock = int.parse(listDetail[index].stock!);
      cartModel.unit = listDetail[index].unit;
      cartModel.qty = int.parse(listDetail[index].qty!);
      cartModel.price = int.parse(listDetail[index].price!);
      cartModel.subTotal = cartModel.qty! * cartModel.price!;
      cartModel.discount = double.parse(listDetail[index].discount!);
      cartModel.total = cartModel.subTotal! + int.parse(cartModel.discount);
      _cartBox.add(cartModel);
    }
  }
}
