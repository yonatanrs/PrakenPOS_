import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/models/Product.dart';

class CartAdapter extends StatelessWidget {
  final Product listProduct;
  final BuildContext context;
  CartAdapter({required this.listProduct, required this.context});

  @override
  Widget build(BuildContext context2) {


    return Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(0)),
      margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange[600]!),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(10)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    listProduct.nameProduct!,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(15)),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(50),
                  child: IconButton(
                    onPressed: () {
                      print("Button Pressed");
                    },
                    color: Colors.red,
                    icon: Icon(Icons.delete),
                    iconSize: ScreenUtil().setSp(20),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Price: "),
                SizedBox(
                  width: ScreenUtil().setWidth(5),
                ),
                Text(
                  '\Rp' + listProduct.price.toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Sub Total: "),
                SizedBox(
                  width: ScreenUtil().setWidth(5),
                ),
                Text('\Rp xxxx',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w300,
                      color: Colors.orange,
                    ))
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Total Qty",
                  style: TextStyle(color: Colors.orange),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      splashColor: Colors.redAccent.shade200,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(6)),
                          child: Icon(
                            Icons.remove,
                            color: Colors.redAccent,
                            size: ScreenUtil().setHeight(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('2'),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {},
                      splashColor: Colors.lightBlue,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
