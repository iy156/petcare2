import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Reportanimal extends StatefulWidget {
  @override
 State <Reportanimal> createState() => _reportanimalState();
}

class _reportanimalState extends State<Reportanimal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  File? _animalImage;
  String? selectedAnimalId;

  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool showSuccessMessage = false;
  String? successMessage;
  String? imageUrl;

  // Pick image function
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _animalImage = File(pickedFile.path);
      });
    }
  }

  // Submit report function
  Future<void> submitReport(BuildContext context) async {
    setState(() {
      isLoading = true;
      showSuccessMessage = false;
      successMessage = null;
      imageUrl = null;
    });

    print("Selected Animal ID: $selectedAnimalId");

    // التحقق من الحقول المطلوبة قبل الإرسال
    if (nameController.text.isEmpty || typeController.text.isEmpty || descriptionController.text.isEmpty || contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء إدخال جميع المعلومات")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    // التحقق من اختيار الصورة
    if (_animalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى اختيار صورة قبل الإبلاغ")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("الرجاء تسجيل الدخول أولًا")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      var uri = Uri.parse("https://10ca-138-199-22-106.ngrok-free.app/api/user/Lost");
      var request = http.MultipartRequest("POST", uri);
      request.headers["Authorization"] = "Bearer $token";

      // إجبار إرسال الحقول المطلوبة
      request.fields["name"] = nameController.text;
      request.fields["type"] = typeController.text;
      request.fields["description"] = descriptionController.text;
      request.fields["contact"] = contactController.text;

      // إضافة الصورة إذا كانت موجودة
      if (_animalImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "image",
          _animalImage!.path,
          filename: basename(_animalImage!.path),
        ));
      }

      print("بيانات الإرسال بعد التعديل: ${request.fields}");

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Response: $responseBody");

      var responseJson = json.decode(responseBody);

      if (response.statusCode == 201) {
        setState(() {
          successMessage = responseJson["message"];
          showSuccessMessage = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage!)),
        );
        // الانتقال إلى الصفحة الرئيسية بعد 2 ثانية
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        });
        
      } else {
        print("Error response: ${response.statusCode} - $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ في إرسال البلاغ: ${responseJson["message"]}")),
        );
      }
    } catch (error) {
      print("Error submitting report: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء إرسال البلاغ")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto", fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Home();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body:
       Padding(
        padding: EdgeInsets.all(16.0),
        child:
        ListView(
          children: [
         Column(
          children: [
            Text("Report Animal Lost",style: TextStyle(
            color: AppColors.c6, fontSize: 20.sp, fontFamily: "Roboto", fontWeight: FontWeight.w400)),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Animal Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: "Animal Type",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: pickImage, child: Text("Choose your animal picture")),
            _animalImage != null ? Image.file(_animalImage!, height: 100) : Container(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : () => submitReport(context),
              child: isLoading ? CircularProgressIndicator() : Text("Send the report"),
            ),
            if (showSuccessMessage) ...[
              Text("تم إرسال البلاغ بنجاح!", style: TextStyle(color: Colors.green)),
            ],
          ],
        ),
          ])
      ),
    );
  }
}
