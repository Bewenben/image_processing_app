// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_processing_app/main.dart';
import '../utils/upload.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

String? path = "";
String? gender = "";
int? age = -1;
String? ageBucket = "";

class UploadPhotoSession extends StatefulWidget {
  const UploadPhotoSession({super.key});

  @override
  State<UploadPhotoSession> createState() => _UploadPhotoSessionState();
}

class _UploadPhotoSessionState extends State<UploadPhotoSession> {
  bool uploading = false;
  XFile? image;

  getData() {
    final docRef = db.collection("data").doc("res");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // print(data["gender"]);
        setState(() {
          gender = data["gender"];
          age = data["age"];
          ageBucket = data["agebucket"];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  uploadPhoto() async {
    setState(() {
      uploading = true;
    });

    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    } else {
      path = image?.path;
    }

    setState(() {
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (path == "") {
      return InkWell(
        onTap: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ));
          await uploadPhoto();
          navigatorKey.currentState!.pop();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                height: 150.h,
                color: Colors.black,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/upload.svg",
                      width: 50.h,
                      height: 50.h,
                      color: Colors.white,
                    ),
                    Text(
                      "Upload an Image",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      "Supported formats: jpeg, png, jpg",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0.r),
                  child: SizedBox(
                      height: 300.h,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ));
                              uploadPhoto();
                              navigatorKey.currentState!.pop();
                            },
                            child: path!.substring(0, 4) == "http"
                                ? CachedNetworkImage(
                                    imageUrl: path!,
                                    placeholder: (context, url) => Center(
                                        child: SizedBox(
                                            width: 60.r,
                                            height: 60.r,
                                            child:
                                                const CircularProgressIndicator())),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      size: 100.r,
                                      color: Colors.white,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(path!),
                                    fit: BoxFit.cover,
                                  ),
                          ))),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.r),
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ));
                  await uploadFile(path);
                  Timer(const Duration(seconds: 5), () async {
                    await getData();
                  });
                  navigatorKey.currentState!.pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          gender != "" ? Center(child: Text("Gender: ${gender!}")) : const Center(child: Text("Detecting...")),
          age != -1 ? Center(child: Text("Age: ${age!}")) : const SizedBox(),
          ageBucket != ""
              ? Center(child: Text("Age Bucket: ${ageBucket!}"))
              : const SizedBox(),
        ],
      );
    }
  }
}
