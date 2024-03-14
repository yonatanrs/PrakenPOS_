import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/ToastCustom.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/absent/AbsentRequest.dart';
import 'package:flutter_scs/models/absent/AbsentResponse.dart';
import 'package:flutter_scs/models/upload/UploadFileResponse.dart';
import 'package:flutter_scs/services/AbsentServices.dart';
import 'package:flutter_scs/services/UploadService.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class AbsentView extends StatefulWidget {
  @override
  _AbsentViewState createState() => _AbsentViewState();
  final String? idSales;
  final AbsentRequest? data;
  AbsentView({this.idSales, this.data});
}

class _AbsentViewState extends State<AbsentView> {
  File? fileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: colorBlueDark, title: Text('Absent')),
      body: Column(children: [
        fileImage == null
            ? SizedBox(height: MediaQuery.of(context).size.height / 3)
            : Container(
                height: MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Image.file(fileImage!)),
              ),
        // Text('Lokasi :' +
        //     widget.data.lattitude.toString() +
        //     ";" +
        //     widget.data.longitude.toString()),
        Center(
          child: Container(
              width: MediaQuery.of(context).size.width / 2,
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
                  child: Text(
                    fileImage == null ? 'Capture Camera' : 'Retake Camera',
                    style: TextStyle(color: colorBlueDark, fontSize: 15),
                  ),
                  onPressed: () => _navigateToCameraScreen())),
        ),
        fileImage == null
            ? SizedBox()
            : Container(
                width: MediaQuery.of(context).size.width / 2,
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
                  onPressed: () {
                    processAbsent();
                  },
                  child: Text(
                    widget.data!.status == 1 ? 'Absent In' : 'Absent Out',
                    style: TextStyle(color: colorBlueDark, fontSize: 15),
                  ),
                ),
              )
      ]),
    );
  }

  void _navigateToCameraScreen() async {
    final _picker = ImagePicker();
    PickedFile? file = await _picker.getImage(source: ImageSource.camera, imageQuality: 85);

    // Check if a file was picked
    if (file != null) {
      // Since file is not null, it's safe to use the `path` property
      GallerySaver.saveImage(file.path).then((value) => print('Image Saved'));
      var formatPath = file.path;
      _validateFileSize(File(formatPath));
    } else {
      // Handle the case where the user did not pick an image
      // For example, show a message or log an error
      ToastCustom().FlutterToast('No image selected', colorError, colorBlueSky);
    }
  }

  void _validateFileSize(File file) async {
    var resultFile = await file.length() / 1024;
    if (resultFile > 15000) {
      ToastCustom().FlutterToast('File too large', colorError, colorBlueSky);
    } else {
      // Upload document
      setState(() {
        fileImage = file;
      });
    }
  }

  void processAbsent() async {
    UploadFileResponse response =
        await UploadService.uploadFile(fileImage!, widget.data!.status!);
    AbsentRequest dataRequest = widget.data!;
    AbsentResponse absentResponse = await AbsentServices.processAbsent(
        AbsentRequest(
            fileNameAbsent: response.fileName,
            lattitude: dataRequest.lattitude,
            longitude: dataRequest.longitude,
            id: dataRequest.id,
            status: dataRequest.status));
    if (absentResponse.error) {
      ToastCustom()
          .FlutterToast(absentResponse.message, colorError, colorAccent);
    } else {
      Navigator.pop(context, 1);
    }
  }
}
