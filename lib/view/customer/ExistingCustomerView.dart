import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardAllCustomerAdapter.dart';
import 'package:flutter_scs/assets/debounce.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:hive/hive.dart';

class ExistingCustomerView extends StatefulWidget {
  ExistingCustomerView({Key? key}) : super(key: key);

  @override
  _ExistingCustomerViewState createState() => _ExistingCustomerViewState();
}

class _ExistingCustomerViewState extends State<ExistingCustomerView> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  List<Customer>? listCustomerReal;
  List<Customer>? _listCustomer;
  bool? isSearching = false;
  Box? _customerBox;

  @override
  void initState() {
    super.initState();
    getAllCustomer();
  }

  Future<Null> listCustomer() async {
    await Future.delayed(Duration(seconds: 2));
    Map<dynamic, dynamic> raw = _customerBox!.toMap();
    List list = raw.values.toList();
    setState(() {
      listCustomerReal = list.map((e) => e as Customer).toList();
      _listCustomer = listCustomerReal;
    });
    return null;
  }

  Future<List<Customer>> getListCustomer() async {
    await Future.delayed(Duration(seconds: 2));
    Map<dynamic, dynamic> raw = _customerBox!.toMap();
    List list = raw.values.toList();
    return list.map((e) => e as Customer).toList();
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
                          _listCustomer = listCustomerReal
                              !.where((element) =>
                                  element.nameCust
                                      !.toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.city
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
            onRefresh: listCustomer,
            child: FutureBuilder(
              future: getListCustomer(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // When the connection is done and no error is present
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasError != true) {
                  _listCustomer == null
                      ? _listCustomer = listCustomerReal = snapshot.data
                      : _listCustomer = _listCustomer;

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
                          CardAllCustomerAdapter(
                            models: _listCustomer![index],
                          )
                  );
                }
                // When there is an error
                else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Center(
                      child: Text("Error: ${snapshot.error.toString()}")
                  );
                }
                // When the connection is not yet established
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
                // Default case: show loading widget
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

  void getAllCustomer() async {
    _customerBox = await Hive.openBox('customers');
  }
}
