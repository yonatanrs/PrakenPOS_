import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';

class CardAllPriceAdapter extends StatelessWidget {
  final PriceDiscount models;
  CardAllPriceAdapter({required this.models});

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
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      models.product!,
                      style: textHeaderCard,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Text(
                      models.price!,
                      style: textChildCard,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(15),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: Text(
                              'Unit : ' + models.unit!,
                              style: textChildCard,
                            )),
                        Flexible(
                            flex: 1,
                            child: Text(
                              'Group : ' + models.group!,
                              style: textChildCard,
                            ))
                      ],
                    ),
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
