import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/RecapStock.dart';
import 'package:flutter_scs/models/Reconsile.dart';
import 'package:flutter_scs/view/reconsile/ReconsileDocumentGenerate.dart';
import 'package:intl/intl.dart';

class CardAllReconsileAdapter extends StatelessWidget {
  final Reconsile models;
  CardAllReconsileAdapter({required this.models});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<Reconsile>(models),
      tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      title: Text(formatDate(models.reconsileDate!),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      children: <Widget>[
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                    ReconsileGenerate().CreatePdf(context, models);
                  },
                  child: Text(
                    'VIEW DOKUMEN',
                    style: TextStyle(color: colorBackground, fontSize: 13),
                  )),
            )),
        Container(
          height: 80,
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text('Name Product')),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: Text('Stock System')),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Text('Stock Fisik')),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Text('Selisih Stock'))
                ]),
          ),
        ),
        for (int counts = 0; counts < models.listRecapStock!.length; counts++)
          cardHistoryReconsile(models.listRecapStock!, context, counts),
        // _buttonAction(context, models),
        SizedBox(height: 8)
      ],
    );
  }

  Widget cardHistoryReconsile(
      List<RecapStock> models, BuildContext context, int index) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text(models[index].nameProduct!)),
                  SizedBox(width: 16),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].qtySystem.toString(),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].qtyFisik.toString(),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].different.toString(),
                        textAlign: TextAlign.center,
                      ))
                ])));
  }

  String formatDate(String date) {
    var result = DateFormat('dd/MMMM/yyyy hh:mm:ss').parse(date);
    var output = DateFormat('dd MMM yyyy');
    return output.format(result);
  }
}


class CardAllReconsileAdapterExhibition extends StatelessWidget {
  final Reconsile models;
  CardAllReconsileAdapterExhibition({required this.models});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<Reconsile>(models),
      tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      title: Text(formatDate(models.reconsileDate!),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      children: <Widget>[
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                    ReconsileGenerate().CreatePdf(context, models);
                  },
                  child: Text(
                    'VIEW DOKUMEN',
                    style: TextStyle(color: colorBackground, fontSize: 13),
                  )),
            )),
        Container(
          height: 80,
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text('Name Product')),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: Text('Stock System')),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Text('Stock Fisik')),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Text('Selisih Stock'))
                ]),
          ),
        ),
        for (int counts = 0; counts < models.listRecapStock!.length; counts++)
          cardHistoryReconsile(models.listRecapStock!, context, counts),
        // _buttonAction(context, models),
        SizedBox(height: 8)
      ],
    );
  }

  Widget cardHistoryReconsile(
      List<RecapStock> models, BuildContext context, int index) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text(models[index].nameProduct!)),
                  SizedBox(width: 16),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].qtySystem.toString(),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].qtyFisik.toString(),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: Text(
                        models[index].different.toString(),
                        textAlign: TextAlign.center,
                      ))
                ])));
  }

  String formatDate(String date) {
    var result = DateFormat('dd/MMMM/yyyy hh:mm:ss').parse(date);
    var output = DateFormat('dd MMM yyyy');
    return output.format(result);
  }
}
