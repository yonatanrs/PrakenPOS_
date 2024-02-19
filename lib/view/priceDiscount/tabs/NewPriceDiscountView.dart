import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/CardAllDiscountAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPriceDiscountView extends StatefulWidget {
  @override
  _NewPriceDiscountViewState createState() => _NewPriceDiscountViewState();
}

class _NewPriceDiscountViewState extends State<NewPriceDiscountView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  late List<PriceDiscount> listPriceDiscReal;
  late List<PriceDiscount> _listPriceDisc;
  bool isSearching = false;
  late String idSales;

  @override
  void initState() {
    super.initState();
    listPriceDisc();
  }

  void getPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idSales = pref.getString("idSales")!;
    });
  }

  Future<Null> listPriceDisc() async {
    var listResult = await PriceDiscount.getAllDiscount(idSales);
    setState(() {
      listPriceDiscReal = listResult;
      _listPriceDisc = listPriceDiscReal;
    });
    return null;
  }

  Future<List<PriceDiscount>> getListProduct() async {
    return await PriceDiscount.getAllDiscount(idSales);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: TextField(
            controller: filterController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Search by Product',
                suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: colorBackground),
                    onPressed: () {
                      String value = filterController.text;
                      _debouncer.run(() {
                        setState(() {
                          _listPriceDisc = listPriceDiscReal
                              .where((element) =>
                              element.product
                              !.toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      });
                    })),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: listPriceDisc,
            child: FutureBuilder(
              future: getListProduct(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    listPriceDiscReal = snapshot.data as List<PriceDiscount>;
                    _listPriceDisc = listPriceDiscReal;
                    if (_listPriceDisc?.length == 0) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text('No Data', style: textDescription),
                            Text('Swipe down for refresh item',
                                style: textDescription),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: _listPriceDisc?.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CardAllDiscountAdapter(
                              models: _listPriceDisc![index]),
                    );
                  } else {
                    print(snapshot.error.toString());
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text('No Data', style: textDescription),
                        Text('Swipe down for refresh item',
                            style: textDescription),
                      ],
                    ),
                  );
                } else {
                  return WidgetStateLoading();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
