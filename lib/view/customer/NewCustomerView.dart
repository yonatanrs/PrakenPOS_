import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardAllCustomerAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomerView extends StatefulWidget {
  @override
  _NewCustomerViewState createState() => _NewCustomerViewState();
}

class _NewCustomerViewState extends State<NewCustomerView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  List<Customer>? listCustomerReal;
  List<Customer>? _listCustomer;
  bool isSearching = false;
  String? idSales;

  void getNewCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    idSales = pref.getString("idSales");
    Customer.getCustomer(idSales!, 2).then((value) {
      listCustomerReal = [];
      listCustomerReal = value;
      _listCustomer = listCustomerReal;
    });
  }

  Future<Null> listCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    idSales = pref.getString("idSales");
    Customer.getCustomer(idSales!, 2).then((value) {
      setState(() {
        listCustomerReal = [];
        listCustomerReal = value;
        _listCustomer = listCustomerReal;
      });
    });

    return null;
  }

  Future<List<Customer>> getListCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    idSales = pref.getString("idSales");
    listCustomerReal = [];
    listCustomerReal = await Customer.getCustomer(idSales!, 2);
    _listCustomer = listCustomerReal;
    return listCustomerReal!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: TextField(
            controller: filterController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                hintText: 'Search by Name or City',
                suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: colorBackground),
                    onPressed: () {
                      String value = filterController.text;
                      _debouncer.run(() {
                        setState(() {
                          _listCustomer = listCustomerReal!.where((element) =>
                                  element.nameCust!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.city!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      });
                    })),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: listCustomer,
            child: FutureBuilder(
              future: getListCustomer(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // Connection done and no error
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasError && snapshot.data != null) {
                    _listCustomer = _listCustomer ?? snapshot.data;
                    if (_listCustomer!.isEmpty) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text('No Data', style: textDescription),
                            Text('Swipe down for refresh item', style: textDescription),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: _listCustomer?.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CardAllCustomerAdapter(models: _listCustomer![index]),
                    );
                  } else {
                    // Handle the error state
                    print(snapshot.error.toString());
                    return Center(
                      child: Text("Error: ${snapshot.error.toString()}"),
                    );
                  }
                }
                // Connection not established
                else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text('No Data', style: textDescription),
                        Text('Swipe down for refresh item', style: textDescription),
                      ],
                    ),
                  );
                }
                // Default case: Loading state
                else {
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
