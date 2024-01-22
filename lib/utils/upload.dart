  import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/bar.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(String? filePath) async {
    File file = File(filePath!);

    try {
      await storage.ref('images').child("image.jpg").putFile(file);
    } on FirebaseException catch (e) {
      Bar.showSnackBar(e.message, Colors.red);
    }

    final link = await storage.ref('images').child("image.jpg").getDownloadURL();
    return link;
  }