import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Regidog extends StatefulWidget {
  @override
  _regidogState createState() => _regidogState();
}

class _regidogState extends State<Regidog> {
  Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? ''; // تأكد من أنك خزنت التوكن مسبقًا
}
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController rabiesController = TextEditingController();
  final TextEditingController parvoController = TextEditingController();
  final TextEditingController cancerController = TextEditingController();
  final TextEditingController wormsController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    typeController.dispose();
    nameController.dispose();
    breedController.dispose();
    dobController.dispose();
    genderController.dispose();
    rabiesController.dispose();
    parvoController.dispose();
    cancerController.dispose();
    wormsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> sendDataToServer() async {
    final uri = Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/user/animals/register');
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nameController.text;
    request.fields['type'] = typeController.text;
    request.fields['breed'] = breedController.text;
    request.fields['gender'] = genderController.text;
    request.fields['dob'] = dobController.text;
    request.fields['rabies'] = rabiesController.text;
    request.fields['parvo'] = parvoController.text;
    request.fields['cancer'] = cancerController.text;
    request.fields['worms'] = wormsController.text;

    if (_image != null) {
      var imageFile = await http.MultipartFile.fromPath('image', _image!.path);
      request.files.add(imageFile);
    }

    var token = await getToken();
    request.headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Animal registered successfully!')),
        );
        
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return Home();
      }));
        
      } else {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Animal"),
       titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto",fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Home();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      
      body:ListView(
        children: [
       Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: typeController, decoration: InputDecoration(labelText: "Type",border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name",border: OutlineInputBorder())),
            SizedBox(height: 10,),
            TextField(controller: breedController, decoration: InputDecoration(labelText: "Breed",border: OutlineInputBorder())),
            SizedBox(height: 10,),
            TextField(controller: genderController, decoration: InputDecoration(labelText: "Gender",border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date of Birth",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, dobController),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: rabiesController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Last Rabies Vaccine",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, rabiesController),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: parvoController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Last Parvo Vaccine",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, parvoController),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cancerController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Last Cancer Vaccine",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, cancerController),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: wormsController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Last Deworming Dose",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, wormsController),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(onPressed: _pickImage, child: Text("Upload Image")),
            _image != null ? Image.file(File(_image!.path), height: 200, width: 200) : Text("No Image Selected"),
            SizedBox(height: 10),
            ElevatedButton(onPressed: sendDataToServer, child: Text("Submit Report")),
          ],
        ),
      ),
      ])
    );
  }
}
