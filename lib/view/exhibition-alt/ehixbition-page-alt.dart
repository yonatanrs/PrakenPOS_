//
// import 'package:flutter/material.dart';
// import 'package:flutter_scs/view/exhibition-alt/exhibition-form-page.dart';
// import 'package:get/get.dart';
//
// class ExhibitionPageAlt extends StatefulWidget {
//   const ExhibitionPageAlt({Key key}) : super(key: key);
//
//   @override
//   _ExhibitionPageAltState createState() => _ExhibitionPageAltState();
// }
//
// class _ExhibitionPageAltState extends State<ExhibitionPageAlt> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Exhibition"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Get.to(ExhibitionFormPage());
//         },
//         icon: Icon(Icons.add),
//         label: Text("Add"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//                 margin: EdgeInsets.only(left: 20, top: 20, right: 20),
//                 child: Text(
//                   "List Exhibition",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                 )),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
