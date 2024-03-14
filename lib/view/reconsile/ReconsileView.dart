import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/adapters/CardAllReconsileAdapter.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Reconsile.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_scs/view/stock/RecapStockView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReconsileView extends StatefulWidget {
  @override
  _ReconsileViewState createState() => _ReconsileViewState();
}

class _ReconsileViewState extends State<ReconsileView> {
  late List<Reconsile> listReconsileReal;
  late List<Reconsile> _listReconsile;
  bool isSearching = false;
  // String _idSales;

  @override
  void initState() {
    super.initState();
    getAllReconsile();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: colorBlueDark,
            title: Text(
              'Reconciliation History',
              style: textHeaderView,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: colorAccent,
              onPressed: () => _onBackPress(),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Create'),
          icon: Icon(Icons.add),
          backgroundColor: colorBlueDark,
          onPressed: () {
            _navigateToReconsile();
          },
        ),
        body: FutureBuilder(
            future: getListReconsile(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError != true) {
                  _listReconsile == null
                      ? _listReconsile = listReconsileReal = snapshot.data
                      : _listReconsile = _listReconsile;
                  if (_listReconsile.length == 0) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'No Data',
                            style: textDescription,
                          ),
                          Text(
                            'Swipe down for refresh item',
                            style: textDescription,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: _listReconsile.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CardAllReconsileAdapter(
                            models: _listReconsile[index],
                          ));
                } else {
                  print(snapshot.error.toString());
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'No Data',
                        style: textDescription,
                      ),
                      Text(
                        'Swipe down for refresh item',
                        style: textDescription,
                      ),
                    ],
                  ),
                );
              } else {
                return WidgetStateLoading();
              }
              return Container();
            }),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }


  void getAllReconsile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var idSales = pref.getString("idSales");
    var value = await Reconsile.getAllReconsile(idSales!);
    setState(() {
      listReconsileReal = value;
      _listReconsile = listReconsileReal;
    });
  }

  Future<List<Reconsile>> getListReconsile() async {
    return listReconsileReal.map((e) => e).toList();
  }

  Future<bool> _navigateToReconsile() async{
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return RecapStockView();
    }));
    return Future.value(false);
  }
}
