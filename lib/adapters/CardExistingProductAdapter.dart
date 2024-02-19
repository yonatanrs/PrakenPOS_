import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';

class CardExistingProductAdapter extends StatelessWidget {
  final Product models;
  CardExistingProductAdapter({required this.models});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
                      models.nameProduct!,
                      style: textHeaderCard,
                    ),
                    SizedBox(height: 8),
                    Text('Unit : ${models.unit}'),
                    // SizedBox(height: 10),
                    // Text('Stock : ${models.stock}'),
                    SizedBox(height: 8),
                    Text('Price : ${models.priceTag}'),
                    SizedBox(height: 8),
                    Text('Discount 1 : ${models.discount ?? 0}'),
                    SizedBox(height: 8),
                    Text('Discount 2 : ${models.discount ?? 0}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
