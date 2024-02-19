import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/InvoiceFormat.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/CheckPayment.dart';
import 'package:flutter_scs/models/Transaction.dart';
import 'package:flutter_scs/view/ListPayment.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomSheetHistoryAction extends StatefulWidget {
  final BuildContext context;
  final Transaction modelTransaction;
  BottomSheetHistoryAction({required this.context, required this.modelTransaction});

  @override
  _BottomSheetHistoryActionState createState() =>
      _BottomSheetHistoryActionState();
}

class _BottomSheetHistoryActionState extends State<BottomSheetHistoryAction> {
  //type untuk membedakan antar status;
  //type (1: updaid, 2: draft, 3: success)
  late String status;
  late String id;
  @override
  void initState() {
    super.initState();
    status = widget.modelTransaction.status!;
    id = widget.modelTransaction.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'More Action',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close_rounded))
                ],
              ),
              SizedBox(height: 8),
              bodyWidget(),
            ],
          )),
        ),
      ),
    );
  }

  Widget bodyWidget() {
    if (status.toLowerCase() == 'draft') {
      return Container(
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
                  amount: widget.modelTransaction.amount!,
                  idOrder: widget.modelTransaction.orderId!,
                );
              }));
            },
            child: Text(
              'Ganti Method Payment',
              style: TextStyle(color: colorBackground, fontSize: 13),
            )),
      );
    } else if (status.toLowerCase() == 'success' ||
        status.toLowerCase() == 'unpaid') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  if (status.toLowerCase() == 'unpaid') {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return ListPayment(
                        amount: widget.modelTransaction.amount!,
                        idOrder: widget.modelTransaction.orderId!,
                      );
                    }));
                  } else {
                    InvoiceFormat().createPdf(id, context, 0);
                  }
                },
                child: Text(
                  status.toLowerCase() == 'unpaid'
                      ? 'Ganti Method Payment'
                      : 'Lihat Invoice Digital',
                  style: TextStyle(color: colorBackground, fontSize: 13),
                )),
          ),
          status.toLowerCase() == 'unpaid'
              ? Container(
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
                        if (status.toLowerCase() == 'unpaid') {
                          CheckPayment.checkPaymentStatus(
                                  widget.modelTransaction.orderId!)
                              .then((value) {
                            if (value.errorCode == "0000") {
                              Fluttertoast.showToast(
                                  msg: value.txStatus == "IP"
                                      ? "Masih Belum Bayar"
                                      : "Sukses",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: colorError,
                                  textColor: colorFontError,
                                  fontSize: ScreenUtil().setSp(16));
                            } else {
                              Fluttertoast.showToast(
                                  msg: value.errorMessage!,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: colorError,
                                  textColor: colorBlueDark,
                                  fontSize: ScreenUtil().setSp(16));
                            }
                          });
                        } else {
                          InvoiceFormat().createPdf(id, context, 1);
                        }
                      },
                      child: Text(
                        'Cek Status',
                        style: TextStyle(color: colorBackground, fontSize: 13),
                      )),
                )
              : SizedBox()
        ],
      );
    }
    return Container();
  }
}
