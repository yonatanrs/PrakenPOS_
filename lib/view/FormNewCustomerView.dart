import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CheckCondition.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/Segment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormNewCustomerView extends StatefulWidget {
  @override
  _FormNewCustomerViewState createState() => _FormNewCustomerViewState();
}

class _FormNewCustomerViewState extends State<FormNewCustomerView>
    with CheckCondition {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _nameCustFocus, _contactFocus, _addressFocus = new FocusNode();
  late String nameCustomer, address, contact, idSales = '';
  Segment segmentSelected = new Segment();
  List<Segment> listSegment = [];
  TextEditingController _searchboxSegment = TextEditingController();
  late String segment;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlueDark,
        title: Text('Form New Customer'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: TextFormField(
                  validator: checkNull,
                  onChanged: (value) {
                    setState(() {
                      nameCustomer = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: _nameCustFocus,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _nameCustFocus, _contactFocus);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Nama Pelanggan Baru *',
                      labelStyle: textLabelForm,
                      hintStyle: textHintForm,
                      errorStyle: textError),
                ),
              ),
              Container(
                child: DropdownSearch<Segment>(
                  validator: (v) => v == null ? "Harus diisi" : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: colorNetral,
                      hintText: "Pilih Segment", // Replaced 'hint' with 'hintText' inside 'InputDecoration'
                    ),
                  ),
                  popupProps: PopupProps.bottomSheet(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      controller: _searchboxSegment,
                    ),
                    loadingBuilder: (context, searchEntry) => Container(child: Text('Loading...')),
                    emptyBuilder: (context, searchEntry) => Center(child: Text('Data Not Found')),
                  ),
                  clearButtonProps: ClearButtonProps(
                    isVisible: true,
                  ),
                  items: listSegment,
                  selectedItem: segmentSelected,
                  compareFn: (valueReal, value) => false,
                  itemAsString: (Segment? item) => item?.nameSegment ?? 'Pilih Segment',
                  onChanged: (value) {
                    setState(() {
                      segment = value!.nameSegment!;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: checkNull,
                  onChanged: (value) {
                    setState(() {
                      contact = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: _contactFocus,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _contactFocus, _addressFocus);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Handphone / Office *',
                      labelStyle: textLabelForm,
                      hintStyle: textHintForm,
                      errorStyle: textError),
                ),
              ),
              Container(
                margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: checkNull,
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  textInputAction: TextInputAction.done,
                  focusNode: _addressFocus,
                  onFieldSubmitted: (term) {
                    _formKey.currentState!.save();
                    _addressFocus.unfocus();
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Alamat *',
                      labelStyle: textLabelForm,
                      hintStyle: textHintForm,
                      errorStyle: textError),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: colorBlueSky,
                          )),
                      padding: EdgeInsets.all(8),
                      backgroundColor: colorNetral,
                    ),
                    onPressed: () => submitNewCustomer(),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: colorBlueDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void submitNewCustomer() {
    Customer _customer = new Customer();
    _customer.codeCust = idSales;
    _customer.nameCust = nameCustomer;
    //? add segment for insert
    _customer.segment = segment;
    _customer.contact = contact;
    _customer.address = address;
    Customer.insertNewCustomer(_customer).then((value) {
      if (value == "0") {
        Navigator.pop(context, 0);
        // _showAlertDialog(_customer, 0);
      } else {
        Fluttertoast.showToast(
            msg: 'Gagal Input Pelanggan Baru',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.redAccent.shade700,
            textColor: Colors.yellow,
            fontSize: ScreenUtil().setSp(16));
      }
    });
  }

  void getPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Segment>? segments = await Segment.getSegment();
    setState(() {
      idSales = pref.getString("idSales")!;
      listSegment = segments!;
    });
  }
}
