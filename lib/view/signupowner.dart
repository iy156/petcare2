import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/view/homeowner.dart';
import 'package:petcare2/view/login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signupowner extends StatefulWidget {
  @override
  State<Signupowner> createState() => _signupownerState();
}

class _signupownerState extends State<Signupowner> {
  bool loading = false;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String password = '';
  String openingTime = '';
  String closingTime = '';
  DateTime dateOfBirth = DateTime.now(); // تغيير إلى DateTime
  File? businessLicense;
  File? storeImage;
  double latitude = 0.0;
  double longitude = 0.0;
  late GoogleMapController mapController;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController openingTimeController = TextEditingController();
  final TextEditingController closingTimeController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  // اختيار صورة للمستند التجاري
  Future<void> pickBusinessLicense() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        businessLicense = File(pickedFile.path);
      });
    }
  }

  // اختيار صورة لمتجر
  Future<void> pickStoreImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        storeImage = File(pickedFile.path);
      });
    }
  }

  // دالة لاختيار التاريخ باستخدام showDatePicker
  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: dateOfBirth,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != dateOfBirth) {
          setState(() {
            dateOfBirth = pickedDate;
            dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(dateOfBirth);
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Date of Birth",
          border: OutlineInputBorder(),
        ),
        child: Text(dateOfBirthController.text.isEmpty
            ? "Select Date"
            : dateOfBirthController.text),
      ),
    );
  }

  // دالة لاختيار الوقت باستخدام TimePicker
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context); // تخصيص الوقت الذي تم اختياره
      });
    }
  }

  // دالة للحصول على الموقع الحالي
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
  }

  // دالة التسجيل
  Future<void> registerOwner() async {
  setState(() {
    loading = true;
  });

  final uri = Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/owner/signup/owner');

  var request = http.MultipartRequest('POST', uri);

  request.fields['firstName'] = firstName;
  request.fields['lastName'] = lastName;
  request.fields['email'] = email;
  request.fields['phone'] = phone;
  request.fields['password'] = password;
  request.fields['storeOpeningTime'] = openingTime;
  request.fields['storeClosingTime'] = closingTime;
  request.fields['latitude'] = latitude.toString();
  request.fields['longitude'] = longitude.toString();
  request.fields['dateOfBirth'] = DateFormat('yyyy-MM-dd').format(dateOfBirth);

  // إضافة الصور للمرفقات
  if (businessLicense != null) {
    request.files.add(await http.MultipartFile.fromPath('commercialRegisterImage', businessLicense!.path));
  }

  if (storeImage != null) {
    request.files.add(await http.MultipartFile.fromPath('storeImage', storeImage!.path));
  }

  try {
    final response = await request.send();

    // قراءة بيانات الـ response فقط مرة واحدة
    final responseBody = await response.stream.bytesToString();

    print('Response body: $responseBody'); // طباعة محتوى الريسبونس

    if (response.statusCode == 201) {
      setState(() {
        loading = false;
      });

      // فك التوكن من الريسبونس
      final responseJson = jsonDecode(responseBody);
      String token = responseJson['token'];

      // تخزين التوكن في SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      // الانتقال إلى صفحة العميل
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return Homeowner();
      }));
    } else {
      setState(() {
        loading = false;
      });
      throw Exception('Registration failed with status: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      loading = false;
    });
    print('Error registering Owner: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Registration failed. Please try again.'),
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Signup'),
      titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto",fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Login();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body:
      ListView(
        children: [
          
       loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder(),),
                    onChanged: (value) => firstName = value,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: 'Last Name',border: OutlineInputBorder(),),
                    onChanged: (value) => lastName = value,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder(),),
                    onChanged: (value) => email = value,
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(labelText: 'Phone',border: OutlineInputBorder(),),
                    onChanged: (value) => phone = value,
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder(),),
                    obscureText: true,
                    onChanged: (value) => password = value,
                  ),
                  SizedBox(height: 20,),

                  _buildDatePickerField(), 
                  SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => _selectTime(context, openingTimeController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: openingTimeController,
                        decoration: InputDecoration(
                          labelText: 'Store Opening Time',
                          hintText: 'Select Time',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectTime(context, closingTimeController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: closingTimeController,
                        decoration: InputDecoration(
                          labelText: 'Store Closing Time',
                          hintText: 'Select Time',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: pickBusinessLicense,
                    child: Text('Pick Business License Image'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: pickStoreImage,
                    child: Text('Pick Store Image'),
                  ),
                  SizedBox(height: 16),

                  // إضافة الخريطة داخل SizedBox صغير
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('current_location'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: Text('Show My Current Location'),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: registerOwner,
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
        ])
    );
  }
}  
