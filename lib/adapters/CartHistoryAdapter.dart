import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/widgets/BottomSheetHistoryAction.dart';
import 'package:flutter_scs/models/Transaction.dart';

class CartHistoryAdapter extends StatelessWidget {
  final Transaction models;
  CartHistoryAdapter({required this.models});

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorDark),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
            child: Text(models.orderId!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorBlueDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          SizedBox(height: 8),
          Divider(color: colorBlueSky),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(8), vertical: 2),
            child: Text(models.nameCustomer!,
                style: TextStyle(
                    color: colorBlueDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                models.status == 'Draft'
                    ? Text('No Payment')
                    : Text(
                        models.typePayment!,
                        style: TextStyle(color: colorBlueDark, fontSize: 12),
                      ),
                Text(
                  models.status!,
                  style: TextStyle(color: colorBlueDark, fontSize: 12),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorBlueDark, fontSize: 15)),
                Text('${models.amount}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorBlueDark, fontSize: 15))
              ],
            ),
          ),
          _buttonAction(context, models)
        ],
      ),
    );
  }

  Widget _buttonAction(BuildContext context, Transaction model) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: colorBlueDark,
                    )),
                backgroundColor: colorNetral,
              ),
              onPressed: () {
                _showBottomSheetAction(context, model);
              },
              child: Text(
                'MORE ACTION',
                style: TextStyle(color: colorBackground, fontSize: 13),
              )),
        ));
  }

  void _showBottomSheetAction(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return BottomSheetHistoryAction(
              context: context, modelTransaction: transaction);
        });
  }
}
