import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/state_management/providers/CartProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

class CardProductAdapter extends StatelessWidget {
  final Product models;
  CardProductAdapter({required this.models});

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<CartProvider>(
      builder: (context, cartValue, _) => Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              cartValue.setCartProduct(models);
              if (cartValue.getMessage != null)
                Fluttertoast.showToast(
                    msg: cartValue.getMessage,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.redAccent.shade700,
                    textColor: Colors.yellow,
                    fontSize: ScreenUtil().setSp(16));
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  // Stack(
                  //   children: <Widget>[
                  //     //new Center(child: new CircularProgressIndicator()),
                  //     new Center(
                  //       child: new FadeInImage.memoryNetwork(
                  //         placeholder: kTransparentImage,
                  //         image:
                  //             'https://picsum.photos/50/70/',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                        child: Text(
                            models.nameProduct! +
                                ' (Stock : ' +
                                models.stock.toString() +
                                ')',
                            style: TextStyle(
                                color: colorBlueDark,
                                fontSize: ScreenUtil().setSp(15))),
                      ),
                      Container(
                        color: colorBlueDark,
                        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
                        child: Text(
                            "Rp. " +
                                MoneyFormatter(
                                        amount: models.price!.toDouble())
                                    .output
                                    .nonSymbol,
                            style: TextStyle(
                                color: colorAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(13))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(10),
            right: ScreenUtil().setHeight(10),
            child: GestureDetector(
              onTap: () {
                cartValue.setCartProduct(models);
                if (cartValue.getMessage != null)
                  Fluttertoast.showToast(
                      msg: cartValue.getMessage,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.redAccent.shade700,
                      textColor: Colors.yellow,
                      fontSize: ScreenUtil().setSp(16));
              },
              child: cartValue.getCarts
                      .where((element) => element.idProduct == models.idProduct)
                      .toList()
                      .isNotEmpty
                  ? Icon(Icons.check_rounded,color: Colors.amber,)
                  : Icon(Icons.check_outlined,color: colorBlueDark,),
                  // : SvgPicture.asset(
                  //     'lib/assets/icons/Favorite1.svg',
                  //     color: colorBlueDark,
                  //   ),
            ),
          )
        ],
      ),
    );
  }
}
