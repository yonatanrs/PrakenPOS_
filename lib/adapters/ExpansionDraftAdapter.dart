
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/widgets/BottomSheetAction.dart';
import 'package:flutter_scs/models/DraftTransaction.dart';
import 'package:money_formatter/money_formatter.dart';

class ExpansionTileAdapter extends StatelessWidget {
  final TransactionDraft headModels;
  ExpansionTileAdapter({required this.headModels});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<TransactionDraft>(headModels),
      tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      title: Text(headModels.idOrder!, style: TextStyle(fontSize: 13)),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(headModels.date!, style: TextStyle(fontSize: 14)),
          Text(
            headModels.nameCustomer!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
      children: <Widget>[
        for (int counts = 0;
            counts < headModels.listDetailTransaction!.length;
            counts++)
          cardDraftHistory(headModels.listDetailTransaction!, context, counts),
        _buttonAction(context, headModels),
        SizedBox(height: 8)
      ],
    );
  }

  Widget cardDraftHistory(
      List<ListDetailTransaction> models, BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(8), vertical: 2),
                child: Text(models[index].nameProduct!,
                    style: TextStyle(
                        color: colorBlueDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              SizedBox(height: 8),
              Divider(color: colorBlueSky),
              SizedBox(height: 8),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
                child: Text(
                    '${models[index].qty} ${models[index].unit} || ' +
                        checkDiscount(models[index].discount!),
                    style: TextStyle(color: colorBlueDark, fontSize: 15)),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorBlueDark, fontSize: 15)),
                    Text(
                        'Rp. ' +
                            MoneyFormatter(
                                    amount: models[index].totalAmount==""?0.0:double.parse(models[index].totalAmount!)).output.nonSymbol,
                        textAlign: TextAlign.center,
                        style: textHeaderCard)
                  ],
                ),
              )
            ]));
  }

  String checkDiscount(String discount) {
    if (discount == '0') {
      return 'No Discount';
    } else {
      return 'Disc : $discount %';
    }
  }

  Widget _buttonAction(
      BuildContext context, TransactionDraft transactionDraft) {
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
              _showBottomSheetAction(context, transactionDraft);
            },
            child: Text(
              'MORE ACTION',
              style: TextStyle(color: colorBackground, fontSize: 13),
            )),
      ),
    );
  }

  void _showBottomSheetAction(
      BuildContext context, TransactionDraft transactionDraft) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return BottomSheetAction(
              context: context, transactionDraft: transactionDraft);
        });
  }
}
