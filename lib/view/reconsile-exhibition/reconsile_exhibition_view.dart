import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/adapters/CardAllReconsileAdapter.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/uistate/widget_state_loading.dart';
import 'package:flutter_scs/models/Reconsile.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_scs/view/reconsile-exhibition/reconsile_exhibition_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReconsileViewExhibition extends StatefulWidget {
  @override
  _ReconsileViewExhibitionState createState() => _ReconsileViewExhibitionState();
}

class _ReconsileViewExhibitionState extends State<ReconsileViewExhibition> {
  List<Reconsile>? listReconsileReal;
  List<Reconsile>? _listReconsile;
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
              'Reconciliation History Exhibition',
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
            Get.to(
              ReconsileExhibitionPage()
            );
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
                  if (_listReconsile?.length == 0) {
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
                      itemCount: _listReconsile?.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CardAllReconsileAdapter(
                            models: _listReconsile![index],
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
    var value = await Reconsile.getAllReconsileExhibition();
    setState(() {
      listReconsileReal = value;
      _listReconsile = listReconsileReal;
    });
  }

  Future<List<Reconsile>> getListReconsile() async {
    // Add a null check before using listReconsileReal
    return listReconsileReal?.map((e) => e).toList() ?? [];
  }
}
