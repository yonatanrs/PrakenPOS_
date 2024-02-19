import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';

class CardAllProductAdapter extends StatelessWidget {
  final Product models;
  CardAllProductAdapter({required this.models});

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
              flex: 3,
              child: Container(
                height: ScreenUtil().setHeight(125),
                width: ScreenUtil().setWidth(110),
                padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
                        fit: BoxFit.cover)),
              ),
            ),
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
                      models.nameProduct!,
                      style: textHeaderCard,
                    ),
                    Text(
                      models.brand!,
                      style: textChildCard,
                    ),
                    Text(
                      models.group!,
                      style: textChildCard,
                    ),
                    Text(
                      models.unit!,
                      style: textChildCard,
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
