import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Customer.dart';

class CardAllCustomerAdapter extends StatelessWidget {
  final Customer models;
  CardAllCustomerAdapter({required this.models});

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
                      '${models.nameCust} - ${models.segment}',
                      style: textHeaderCard,
                    ),
                    Text(
                      models.address!,
                      style: textChildCard,
                    ),
                    models.city == null
                        ? SizedBox()
                        : Text(
                            'City : ' + models.city!,
                            style: textChildCard,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    models.contactPerson == '' || models.contactPerson == null
                        ? models.contactPerson == ''
                            ? SizedBox()
                            : Text(
                                'Contact : ' + models.contact!,
                                style: textChildCard,
                              )
                        : Text(
                            'Contact Person : ' +
                                models.contactPerson! +
                                ' (' +
                                models.contact! +
                                ')',
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
