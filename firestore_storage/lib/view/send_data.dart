import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_storage/view/get_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class SendData extends StatefulWidget {
  const SendData({super.key});

  @override
  State<SendData> createState() => _SendDataState();
}

class _SendDataState extends State<SendData> {
  final ImagePicker _imagePicker = ImagePicker();
  String ImageName = '';
  XFile? image;

  Future<void> _getImage() async {
    final XFile? pickerImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickerImage;
    });
  }

  Future<void> _uploadImage() async {
    if (image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child('images').child(image!.name);
      UploadTask uploadTask = ref.putFile(File(image!.path));

      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('imageDetails').add({
          'name': ImageName,
          'imageUrl': downloadURL,
        });
        setState(() {
          image = null;
          ImageName = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Send data'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: 'Enter image name'),
            onChanged: (value) {
              setState(() {
                ImageName = value;
              });
            },
          ),
          ElevatedButton(
              onPressed: () {
                _getImage();
              },
              child: Text('Select image',)),
          image == null
              ? Text('no image selected',style: TextStyle(color: Colors.black),)
              : Image.file(File(image!.path)),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text('Upload image')),
          SizedBox(
            height: 100.h,
          ),
          ElevatedButton(
              onPressed: () {
                Get.off(GetData());
              },
              child: Text('page Get Data')),
        ],
      ),
    );
  }
}
