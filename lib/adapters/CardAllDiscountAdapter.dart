import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';

class CardAllDiscountAdapter extends StatelessWidget {
  final PriceDiscount models;
  CardAllDiscountAdapter({required this.models});

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
                  children: <Widget>[
                    Text(
                      models.product!,
                      style: textHeaderCard,
                    ),
                    SizedBox(height: 8),
                    Text('Customer : ' + models.customer!, style: textChildCard),
                    SizedBox(height: 8),
                    Text('Price : ${models.price}', style: textChildCard),
                    SizedBox(height: 8),
                    Text('Disc 1 : ' + models.disc1Tag!, style: textChildCard),
                    SizedBox(height: 8),
                    Text('Disc 2 : ' + models.disc2Tag!, style: textChildCard),
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: textChildCard,
                                ),
                                Text(
                                  'To',
                                  style: textChildCard,
                                ),
                              ],
                            )),
                        Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${models.fromDate}',
                                  style: textChildCard,
                                ),
                                Text(
                                  '${models.endDate}',
                                  style: textChildCard,
                                ),
                              ],
                            ))
                      ],
                    )
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
