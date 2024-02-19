import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:collection/collection.dart';
import '../../models/PostTransactionModel.dart';
import '../../models/PostTransactionModelDummy.dart';
import '../MainMenuView.dart';
import 'customer-wrapper.dart';
import 'exhibition-and-customer-wrapper.dart';
import 'exhibition-presenter.dart';
import 'exhibition-product-input-state.dart';
import 'exhibition-product-model.dart';
import 'exhibition-wrapper.dart';
import 'qty_text_input_formatter.dart';

class ExhibitionPage extends StatefulWidget {
  int? initialindex;
  ExhibitionPage({Key? key, this.initialindex}) : super(key: key);

  @override
  _ExhibitionPageState createState() => _ExhibitionPageState();
}

class _ExhibitionPageState extends State<ExhibitionPage> {

  dialog(){
    Future.delayed(Duration.zero, () => Get.defaultDialog(
        barrierDismissible: false,
        title: "Transaction Type",
        onWillPop: () {
          return Future.value(false);
        },
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  exhibitiionPresenter.pilihDialog.value = "OTS";
                  Get.back();
                },
                child: Text("OTS"),
              ),
              ElevatedButton(
                onPressed: () {
                  exhibitiionPresenter.pilihDialog.value = "CBD";
                  Get.back();
                },
                child: Text("CBD"),
              )
            ],
          ),
        )
    ));
  }

  Widget cardProduct(ExhibitionProgramInputState exhibitionProgramInputState) {
    ExhibitionProductModel? exhibitionProductModel = exhibitionProgramInputState.exhibitionProductModel;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Produk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Nama Produk :"),
                  Spacer(),
                  Text(exhibitionProgramInputState.exhibitionProductModel != null ? exhibitionProgramInputState.exhibitionProductModel!.nameProduct! : "(Empty)"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Qty :"),
                  Spacer(),
                  Text(exhibitionProgramInputState.qty!.text),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Uom :"),
                  Spacer(),
                  Text(exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice ?? "(Not Selected)"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Discount :"),
                  Spacer(),
                  Text(exhibitionProgramInputState.disc!.text),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Harga :"),
                  Spacer(),
                  Text(exhibitionProgramInputState.disc!.text),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardProductResponse(PostTransactionModel postTransactionModel) {
    List<Widget> columnWidget = postTransactionModel.lines!.map<Widget>((value){
      return Column(
        children: [
          postTransactionModel.lines!.first==value?Row(
            children: [
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onSurface: Colors.grey,
                ),
                onPressed: (){
                  setState(() {
                    // exhibitiionPresenter.generateInvoice();
                  });
                },
                child: const Text('Generate PDF'),
              )
            ],
          ):SizedBox(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data Produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Produk :"),
                      Spacer(),
                      Expanded(
                        child: Text(value.nameProduct!,textAlign: TextAlign.right,),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Qty :"),
                      Spacer(),
                      Text(value.qty.toString()),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Uom :"),
                      Spacer(),
                      Text(value.unit!),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Discount :"),
                      Spacer(),
                      Text(value.discount.isNull?"0 %":"${value.discount.toString()} %"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Harga Original:"),
                      Spacer(),
                      Text("Rp. ${MoneyFormatter(amount: value.price!.toDouble()).output.withoutFractionDigits}"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Harga Total:"),
                      Spacer(),
                      Text("Rp. ${MoneyFormatter(amount: value.totalAmount!.toDouble()).output.withoutFractionDigits}"),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: columnWidget
        ),
      )
    );
  }

  Widget cardCustomer(CustomerWrapper customerWrapper) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Customer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Nama :"),
                  Spacer(),
                  Text(customerWrapper.customerNameTextEditingController!.text),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("No Telp :"),
                  Spacer(),
                  Text(customerWrapper.noTelpTextEditingController!.text),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Email :"),
                  Spacer(),
                  Text(customerWrapper.emailTextEditingController!.text),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardCustomerResponse(PostTransactionModel postTransactionModel) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Customer",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Nama :"),
                  Spacer(),
                  Text(postTransactionModel.nameCust!),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("No Telp :"),
                  Spacer(),
                  Text(postTransactionModel.contact!),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Email :"),
                  Spacer(),
                  Text(postTransactionModel.email!),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget formCustomer(CustomerWrapper customerWrapper) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "New Order",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "   ( ${exhibitiionPresenter.pilihDialog} )",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Cust. Name :"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 20,
                      child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: customerWrapper.customerNameTextEditingController
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Company :"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                        height: 20,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.emailAddress,
                          controller: customerWrapper.emailTextEditingController,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Mobile No. :"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                        height: 20,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: customerWrapper.noTelpTextEditingController,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPriceDialog(int index, ExhibitionProgramInputState exhibitionProgramInputState) {
    TextEditingController priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ubah Harga"),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Masukkan harga baru",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                double newPrice = double.parse(priceController.text);
                exhibitiionPresenter.changeHarga(index, newPrice);
                Navigator.of(context).pop();
              },
              child: Text("Ubah"),
            ),
          ],
        );
      },
    );
  }


  Widget formProduct(
    int index,
    ExhibitionProgramInputState exhibitionProgramInputState,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        elevation: 10,
        borderOnForeground: true,
        semanticContainer: true,
        shadowColor: Colors.blueGrey,
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Data Produk", //${index+=1}
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => exhibitiionPresenter.addItem(),
                    icon: Icon(Icons.add,size: 20,)
                  ),
                  IconButton(
                    onPressed: () => exhibitiionPresenter.removeItem(index),
                    icon: Icon(Icons.delete,size: 20,)
                  ),
                ],
              ),
              Divider(color: Colors.black),
              SizedBox(
                height: 0,
              ),
              Row(
                children: [
                  Text("Product Name :"),
                  SizedBox(width: 10),
                  exhibitionProgramInputState.exhibitionProductModel.isNull?Expanded(
                    child: SearchChoices.single(
                      isExpanded: true,
                      padding: 2,
                      value: exhibitionProgramInputState.productInputPageDropdownState!.selectedChoice!,
                      hint: Text(
                        "Product",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: exhibitionProgramInputState.productInputPageDropdownState!.choiceList!.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.value!),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => exhibitiionPresenter.changeProduct(index, value)
                    ),
                  ):
                  exhibitionProgramInputState.productInputPageDropdownState!.selectedChoice!=null?Expanded(
                    child: SearchChoices.single(
                        isExpanded: true,
                        padding: 2,
                        value: exhibitionProgramInputState.productInputPageDropdownState!.selectedChoice,
                        hint: Text(
                          "Product",
                          style: TextStyle(fontSize: 12),
                        ),
                        items: exhibitionProgramInputState.productInputPageDropdownState!.choiceList!.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.value!),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) => exhibitiionPresenter.changeProduct(index, value)
                    ),
                  ):Expanded(
                    child: Text(
                      exhibitionProgramInputState.exhibitionProductModel != null ? exhibitionProgramInputState.exhibitionProductModel!.nameProduct! : "(Empty)",
                      maxLines: 5,
                    )
                  ),
                  exhibitionProgramInputState.exhibitionProductModel==null||exhibitionProgramInputState.productInputPageDropdownState!.selectedChoice!=null?SizedBox():IconButton(
                    onPressed: () => exhibitiionPresenter.resetProductToEmpty(index),
                    icon: Icon(Icons.clear)
                  ),
                  IconButton(
                    onPressed: () => exhibitiionPresenter.startBarcodeScanStream(exhibitionProgramInputState),
                    // onPressed: () => exhibitiionPresenter.scanBarcodeNormal(exhibitionProgramInputState),
                    icon: Icon(Icons.scanner)
                  )
                ],
              ),
              exhibitionProgramInputState.stock!.text.isEmpty?SizedBox():SizedBox(height: 8,),
              exhibitionProgramInputState.stock!.text.isEmpty?SizedBox():Column(
                children: [
                  Container(
                    height: 18,
                    child: Row(
                      children: [
                        Text("Stock :"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text("${exhibitiionPresenter.pilihDialog=="CBD"?"CBD":exhibitionProgramInputState.stock!.text.toString()}")
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(
                      indent: 45,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),

              Container(
                height: 25,
                child: Row(
                  children: [
                    Text("Qty :"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: exhibitionProgramInputState.qty,
                        decoration: InputDecoration(
                        ),
                          // double.parse(exhibitionProgramInputState.qty.text)>=double.parse(exhibitionProgramInputState.stock.text.split(' ')[0])
                        onChanged: (value){
                          exhibitiionPresenter.changeQty(index, exhibitionProgramInputState.qty!.text);
                        },
                      )
                    ),
                  ],
                ),
              ),
              Container(
                // height: 70,
                child: Row(
                  children: [
                    Text("Uom :"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SearchChoices.single(
                        padding: 2,
                        isExpanded: true,
                        value: exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice,
                        hint: Text(
                          "Unit",
                          style: TextStyle(fontSize: 12),
                        ),
                        items: exhibitionProgramInputState.unitInputPageDropdownState!.choiceList!.map((item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) => exhibitiionPresenter.changeUnit(index, value)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: () {
                  _showPriceDialog(index, exhibitionProgramInputState);
                },
                child: Row(
                  children: [
                    Text("Harga :"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "Rp ${MoneyFormatter(amount: exhibitionProgramInputState.hargaOriginal!.text == "" ? 0.0 : double.parse(exhibitionProgramInputState.hargaOriginal!.text)).output.withoutFractionDigits}",
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 50,
                color: Colors.black,
              ),
              Container(
                height: 35,
                child: Row(
                  children: [
                    Text("Discount (%):"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                          height: 20,
                          child: TextFormField(
                            enableInteractiveSelection: false,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            readOnly: true,
                            controller: exhibitionProgramInputState.disc,
                            decoration: InputDecoration(
                                // suffixText: "%"
                            ),
                            textInputAction: TextInputAction.send,
                            onTap: (){
                              Get.defaultDialog(
                                title: "",
                                barrierDismissible: false,
                                onWillPop: () {
                                  return Future.value(false);
                                },
                                content: TextFormField(
                                  controller: exhibitionProgramInputState.disc,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    prefixText: "Set Discount : ",
                                    suffixText: "%"
                                  ),
                                ),
                                onConfirm: (){
                                  exhibitiionPresenter.changeDiscAlt(index, exhibitionProgramInputState.disc!.text);
                                  Get.back();
                                }
                              );
                            },
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Sub Total :"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                        "Rp ${MoneyFormatter(amount: exhibitionProgramInputState.harga!).output.withoutFractionDigits}",
                      )
                  ),
                ],
              ),
              Divider(
                indent: 65,
                color: Colors.black,
              )
            ],
          )
        ),
      ),
    );
  }

  final exhibitiionPresenter = Get.put(ExhibitionPresenter());
  final tabController = Get.put(MyTabController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.initialindex.isNull){
      tabController.initialIndex = 0;
      Future.delayed(Duration.zero, () => Get.defaultDialog(
          barrierDismissible: false,
          title: "Transaction Type",
          onWillPop: () {
            return Future.value(false);
          },
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    exhibitiionPresenter.pilihDialog.value = "OTS";
                    Get.back();
                  },
                  child: Text("OTS"),
                ),
                ElevatedButton(
                  onPressed: () {
                    exhibitiionPresenter.pilihDialog.value = "CBD";
                    Get.back();
                  },
                  child: Text("CBD"),
                )
              ],
            ),
          )
      ));
    }else{
      tabController.initialIndex = widget.initialindex!;
      tabController.controller.animateTo(tabController.initialIndex);
    }
    print("objectTabCont InitialIndex ${tabController.initialIndex}");
  }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }

  double sumList(List<double?> list) {
    return list.fold(0.0, (previousValue, element) => previousValue + (element ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Exhibition"),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: DefaultTabController(
            initialIndex: tabController.initialIndex,
            length: 3,
            child: Column(
              children: [
                SizedBox(height: 3,),
                TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  isScrollable: false,
                    controller: tabController.controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index){
                      tabController.initialIndex = 0;
                      print("objectTabCont InitialIndex Tab ${tabController.initialIndex}");
                      if(index==0){
                        tabController.initialIndex = 0;
                        Future.delayed(Duration.zero, () => Get.defaultDialog(
                            barrierDismissible: false,
                            title: "Transaction Type",
                            onWillPop: () {
                              return Future.value(false);
                            },
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      exhibitiionPresenter.pilihDialog.value = "OTS";
                                      Get.back();
                                    },
                                    child: Text("OTS"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      exhibitiionPresenter.pilihDialog.value = "CBD";
                                      Get.back();
                                    },
                                    child: Text("CBD"),
                                  )
                                ],
                              ),
                            )
                        ));
                      }
                    },
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.red,
                    labelColor: Colors.black,
                    indicator: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue,
                      border: Border.all(color: Colors.black)
                    ),
                    padding: const EdgeInsets.only(bottom: 5),
                    indicatorPadding: EdgeInsets.all(5),
                    tabs: [
                      Tab(
                        text: "Create Order",
                      ),
                      Tab(
                        text: "All History",
                      ),
                      Tab(
                        text: "All Cache",
                      ),
                    ]
                ),
                Divider(
                  color: Colors.black87,
                ),
                Container(
                  //Add this to give height
                  height: Get.height,
                  width: Get.width,
                  // constraints: BoxConstraints.expand(),
                  child: TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      controller: tabController.controller,
                      children: [
                    // page1
                    Container(
                      height: Get.size.height,
                      width: Get.size.width,
                      child: Obx(() {
                        List<ExhibitionProgramInputState> exhibitionProgramInputState = exhibitiionPresenter.exhibitionProgramInputStateRx.value.exhibitionProgramInputState!;
                        List<Widget> productFormWidget = [];
                        for (int i = 0; i < exhibitionProgramInputState.length; i++) {
                          productFormWidget.add(formProduct(i, exhibitionProgramInputState[i]));
                        }
                        print("productFormWidget :${productFormWidget}");
                        return DraggableScrollableSheet(
                            snap: true,
                            initialChildSize: 1,
                            minChildSize: 1,
                            maxChildSize: 1,
                            expand: false,
                            builder: (context, scrollController) {
                              List<Widget> listViewWidget = [
                                Obx(() => formCustomer(exhibitiionPresenter.customerWrapperRx.value)),
                                SizedBox(
                                  height: 20,
                                ),
                              ];
                              if (exhibitionProgramInputState.length == 0) {
                                listViewWidget.add(
                                    Center(
                                      child: ElevatedButton(
                                          child: Text("Add Product"),
                                          onPressed: () => exhibitiionPresenter.addItem()
                                      ),
                                    )
                                );
                              } else {
                                listViewWidget.addAll(productFormWidget.reversed);
                              }
                              if (exhibitionProgramInputState.length > 0) {
                                final totalHarga = exhibitionProgramInputState.map((e) => e.harga).toList();
                                listViewWidget.add(
                                    Container(
                                      // margin: EdgeInsets.only(top: 20, left: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,bottom: MediaQuery.of(context).size.height * 0.5),
                                            child: Center(
                                              child: exhibitiionPresenter.isTap.value==false?ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green,
                                                  ),
                                                  child: Text("Submit"),
                                                  onPressed: ()async{
                                                    setState(() {
                                                      exhibitiionPresenter.isTap.value = true;
                                                      exhibitiionPresenter.processTransaction();
                                                      exhibitiionPresenter.processTransactionDummy();
                                                    });
                                                  }
                                              ):Center(child: CircularProgressIndicator(),),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20, left: 10),
                                            child: Card(
                                                elevation: 10,
                                                borderOnForeground: true,
                                                semanticContainer: true,
                                                shadowColor: Colors.blueGrey,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(
                                                    "Order Total : Rp ${MoneyFormatter(amount: sumList(totalHarga)).output.withoutFractionDigits}",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),),
                                                )),
                                          ),

                                        ],
                                      ),
                                    )
                                );
                              }
                              return ListView(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  children: listViewWidget
                              );
                            }
                        );
                      }),
                    ),
                    //page2
                    Container(
                      height: Get.size.height,
                      width: Get.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                              child: Text(
                                "Order List",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: Obx(() {
                                PostTransactionModelDummy postTransactionModelDummy = exhibitiionPresenter.postTransactionModelDummyRx.value;
                                List<PostTransactionModel> postTransactionModelList = postTransactionModelDummy.postTransactionModelList!;
                                return ListView.builder(
                                  // physics: NeverScrollableScrollPhysics(),
                                    itemCount: exhibitiionPresenter.dataListExhibition.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index){
                                      print("coeet : ${exhibitiionPresenter.dataListExhibition}");
                                      return InkWell(
                                        onTap: ()async{
                                          int indexes = index;
                                          print("indexes $indexes");
                                          await exhibitiionPresenter.getListDetailExhibition(exhibitiionPresenter.dataListExhibition[index]['idOrder']);
                                          Get.bottomSheet(
                                            // Container(),
                                              ListView.builder(
                                                  itemCount: exhibitiionPresenter.dataListDetailExhibition?.length??0,
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      children: [
                                                        index==0?
                                                        Row(
                                                          children: [
                                                            Spacer(),
                                                            TextButton(
                                                              style: TextButton.styleFrom(
                                                                primary: Colors.white,
                                                                backgroundColor: Colors.lightBlue,
                                                                onSurface: Colors.grey,
                                                              ),
                                                              onPressed: (){
                                                                exhibitiionPresenter.generateInvoice(exhibitiionPresenter.dataListDetailExhibition, exhibitiionPresenter.dataListExhibition[index]['salesOrderId'], exhibitiionPresenter.dataListExhibition[indexes]);
                                                              },
                                                              child: const Text('Preview'),
                                                            )
                                                          ],
                                                        )
                                                            :SizedBox(),
                                                        Card(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Data Produk",
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Product Name :"),
                                                                    Spacer(),
                                                                    Expanded(
                                                                      child: Text(exhibitiionPresenter.dataListDetailExhibition[index]['nameProduct'],textAlign: TextAlign.right,),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text("Qty :"),
                                                                    Spacer(),
                                                                    Text(exhibitiionPresenter.dataListDetailExhibition[index]['qty'].toString()),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text("Uom :"),
                                                                    Spacer(),
                                                                    Text(exhibitiionPresenter.dataListDetailExhibition[index]['unit']),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text("Discount :"),
                                                                    Spacer(),
                                                                    // Text(exhibitiionPresenter.dataDraftExhibition[index]['Lines'][index]['discount'].isNullOrBlank?"0 %":"${exhibitiionPresenter.dataDraftExhibition[index]['Lines'][index]['discount'].toString()} %"),
                                                                    Text("${exhibitiionPresenter.dataListDetailExhibition[index]['discount']==null?"0":exhibitiionPresenter.dataListDetailExhibition[index]['discount'].toString()} %"),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text("Harga Original:"),
                                                                    Spacer(),
                                                                    Text("Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataListDetailExhibition[index]['price'].toDouble()).output.withoutFractionDigits}"),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text("Harga Total:"),
                                                                    Spacer(),
                                                                    Text("Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataListDetailExhibition[index]['totalAmount'].toDouble()).output.withoutFractionDigits}"),
                                                                    // Text("${exhibitiionPresenter.dataListDetailExhibition[index]['totalAmount']}"),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  })
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "ID Order :",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        exhibitiionPresenter.dataListExhibition[index]['salesOrderId']??"Kosong",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Date Order :",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        exhibitiionPresenter.dataListExhibition[index]['date'],
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Cust. Name :"),
                                                      Spacer(),
                                                      Text(exhibitiionPresenter.dataListExhibition[index]['name']),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Company :"),
                                                      Spacer(),
                                                      Text(exhibitiionPresenter.dataListExhibition[index]['company']??""),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Mobile No. :"),
                                                      Spacer(),
                                                      Text(exhibitiionPresenter.dataListExhibition[index]['tlp']??"Kosong"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Order Amount :",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        // totalBelanja,
                                                        "Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataListExhibition[index]['totalAmount']).output.withoutFractionDigits}",
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                );
                              })
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                          height: Get.size.height,
                          width: Get.size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                                  child: Text(
                                    "Order List Cache",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  )
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  child: Obx(() {
                                    PostTransactionModelDummy postTransactionModelDummy = exhibitiionPresenter.postTransactionModelDummyRx.value;
                                    List<PostTransactionModel> postTransactionModelList = postTransactionModelDummy.postTransactionModelList!;
                                    log("dataDraft :${exhibitiionPresenter.dataDraftExhibition}");
                                    return ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                        itemCount: exhibitiionPresenter.dataDraftExhibition.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index){

                                          return InkWell(
                                            onTap: ()async{
                                              int indexes = index;
                                              print("indexes $indexes");
                                              await exhibitiionPresenter.getListDetailExhibition(exhibitiionPresenter.dataListExhibition[index]['idOrder']);
                                              Get.bottomSheet(
                                                // Container(),
                                                  ListView.builder(
                                                      itemCount: exhibitiionPresenter.dataListDetailExhibition?.length??0,
                                                      itemBuilder: (context, index) {
                                                        return Column(
                                                          children: [
                                                            index==0?
                                                            Row(
                                                              children: [
                                                                Spacer(),
                                                                TextButton(
                                                                  style: TextButton.styleFrom(
                                                                    primary: Colors.white,
                                                                    backgroundColor: Colors.lightBlue,
                                                                    onSurface: Colors.grey,
                                                                  ),
                                                                  onPressed: (){
                                                                    print("kow :$index ${exhibitiionPresenter.dataListDetailExhibition}");
                                                                    exhibitiionPresenter.generateInvoice(exhibitiionPresenter.dataListDetailExhibition, exhibitiionPresenter.dataListExhibition[index]['salesOrderId'], exhibitiionPresenter.dataListExhibition[indexes]);
                                                                  },
                                                                  child: const Text('Preview'),
                                                                )
                                                              ],
                                                            )
                                                                :SizedBox(),
                                                            Card(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(15.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Data Produk",
                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 20,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text("Product Name :"),
                                                                        Spacer(),
                                                                        Expanded(
                                                                          child: Text(exhibitiionPresenter.dataListDetailExhibition[index]['nameProduct'],textAlign: TextAlign.right,),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text("Qty :"),
                                                                        Spacer(),
                                                                        Text(exhibitiionPresenter.dataListDetailExhibition[index]['qty'].toString()),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text("Uom :"),
                                                                        Spacer(),
                                                                        Text(exhibitiionPresenter.dataListDetailExhibition[index]['unit']),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text("Discount :"),
                                                                        Spacer(),
                                                                        // Text(exhibitiionPresenter.dataDraftExhibition[index]['Lines'][index]['discount'].isNullOrBlank?"0 %":"${exhibitiionPresenter.dataDraftExhibition[index]['Lines'][index]['discount'].toString()} %"),
                                                                        Text("${exhibitiionPresenter.dataListDetailExhibition[index]['discount']==null?"0":exhibitiionPresenter.dataListDetailExhibition[index]['discount'].toString()} %"),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text("Harga Original:"),
                                                                        Spacer(),
                                                                        Text("Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataListDetailExhibition[index]['price'].toDouble()).output.withoutFractionDigits}"),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text("Harga Total:"),
                                                                        Spacer(),
                                                                        Text("Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataListDetailExhibition[index]['totalAmount'].toDouble()).output.withoutFractionDigits}"),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      })
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10, right: 10),
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "ID Order :",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            exhibitiionPresenter.dataDraftExhibition[index]['Lines'][0]['idOrder']??"Kosong",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Date Order :",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            exhibitiionPresenter.dataListExhibition[index]['date']??"Kosong",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Cust. Name :"),
                                                          Spacer(),
                                                          Text(exhibitiionPresenter.dataDraftExhibition[index]['nameCust']??"Kosong"),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Company :"),
                                                          Spacer(),
                                                          Text(exhibitiionPresenter.dataDraftExhibition[index]['email']??""),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Mobile No. :"),
                                                          Spacer(),
                                                          Text(exhibitiionPresenter.dataDraftExhibition[index]['contact']??"Kosong"),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Order Amount :",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            // totalBelanja,
                                                            "Rp. ${MoneyFormatter(amount: exhibitiionPresenter.dataDraftExhibition[index]['total']??0.0).output.withoutFractionDigits}",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  })
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.2,
                              ),
                            ],
                          ),
                  ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
