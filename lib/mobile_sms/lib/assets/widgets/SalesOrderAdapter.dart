import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Promosi.dart';
import 'TextResultCard.dart';


class SalesOrderAdapter extends StatelessWidget {
  Promosi models = new Promosi();
  SalesOrderAdapter({required this.models});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorDark),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          TextResultCard(
            context: context,
            title: 'No. Sales Order',
            value: models.nomorPP??"",
          ),
          TextResultCard(
            context: context,
            title: 'Product',
            value: models.product??"",
          ),
          TextResultCard(
            context: context,
            title: 'Qty',
            value: models.qty.toString(),
          ),
          TextResultCard(
            context: context,
            title: 'Unit',
            value: models.unitId??"",
          ),
          TextResultCard(
            context: context,
            title: 'Price',
            value: models.price??"",
          ),
          TextResultCard(
            context: context,
            title: 'Disc(%)',
            value: models.disc1??"",
          ),
          TextResultCard(
            context: context,
            title: "Total",
            value: models?.totalAmount??"",
          ),
        ],
      ),
    );
  }
}
