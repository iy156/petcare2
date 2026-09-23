import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/homedoctor.dart';
import 'package:petcare2/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد مكتبة SharedPreferences

class Signupdoctor extends StatefulWidget {
  const Signupdoctor({super.key});

  @override
  State<Signupdoctor> createState() => _SignupdoctorState();
}

class _SignupdoctorState extends State<Signupdoctor> {
  File? _licenseImage;
  File? _clinicImage;
  final picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  GoogleMapController? mapController;
  Marker? selectedMarker;
  double? selectedLatitude;
  double? selectedLongitude;

  Future<void> pickImage(bool isLicense) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if (isLicense) {
          _licenseImage = File(pickedFile.path);
        } else {
          _clinicImage = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      selectedLatitude = position.latitude;
      selectedLongitude = position.longitude;
      selectedMarker = Marker(
        markerId: MarkerId("selected-location"),
        position: LatLng(selectedLatitude!, selectedLongitude!),
      );
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(selectedLatitude!, selectedLongitude!), 15),
      );
    });
  }

  Future<void> registerVet() async {
  var uri = Uri.parse("https://d189-212-102-51-89.ngrok-free.app/api/veterinary/signup/Veterinary");
  var request = http.MultipartRequest('POST', uri);

  request.fields['firstName'] = firstNameController.text;
  request.fields['lastName'] = lastNameController.text;
  request.fields['email'] = emailController.text;
  request.fields['phone'] = phoneController.text;
  request.fields['password'] = passwordController.text;
  request.fields['dateOfBirth'] = dateOfBirthController.text;
  request.fields['clinicOpeningTime'] = openingTimeController.text;
  request.fields['clinicClosingTime'] = closingTimeController.text;
  request.fields['latitude'] = selectedLatitude.toString();
  request.fields['longitude'] = selectedLongitude.toString();

  if (_licenseImage != null) {
    request.files.add(await http.MultipartFile.fromPath('commercialRegisterImage', _licenseImage!.path));
  }

  if (_clinicImage != null) {
    request.files.add(await http.MultipartFile.fromPath('clinicImage', _clinicImage!.path));
  }

  var response = await request.send();

  // تحويل الـ stream إلى نص وطباعة الريسبونس
  final responseBody = await response.stream.bytesToString();
  print("الريسبونس: $responseBody");

  if (response.statusCode == 201) {
    // التحقق من وجود الرسالة في الريسبونس
    var responseJson = jsonDecode(responseBody);
    if (responseJson['message'] == "User registered successfully") {
      print(" Registrarion successful");

      // تخزين التوكن في SharedPreferences
      final token = responseJson['token']; // استخراج التوكن من الريسبونس
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', token); // تخزين التوكن

      // الانتقال إلى الشاشة التالية
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return Homedoctor();
      }));
    } else {
      print("Registration Falied : ${responseJson['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Falied  : ${responseJson['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    print("Registration Falied");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' Registration Falied,please Try agine'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  Future<void> selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = DateFormat('HH:mm').format(
        DateTime(0, 1, 1, picked.hour, picked.minute),
      );
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup"),
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
        ),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: "First Name ",border: OutlineInputBorder())),
            SizedBox(height: 20,),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: " Last Name",border: OutlineInputBorder(),)),
             SizedBox(height: 20,),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email ",border: OutlineInputBorder(),)),
             SizedBox(height: 20,),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Number ",border: OutlineInputBorder(),)),
             SizedBox(height: 20,),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password ",border: OutlineInputBorder(),)),
             SizedBox(height: 20,),
            TextField(
              controller: dateOfBirthController,
              decoration: InputDecoration(labelText: " Date Of Birth",border: OutlineInputBorder(),),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(date);
                }
              },
            ),
             SizedBox(height: 20,),
            TextField(
              controller: openingTimeController,
              decoration: InputDecoration(labelText: " Open time",border: OutlineInputBorder(),),
              onTap: () => selectTime(openingTimeController),
            ),
             SizedBox(height: 20,),
            TextField(
              controller: closingTimeController,
              decoration: InputDecoration(labelText: " Closing time",border: OutlineInputBorder(),),
              onTap: () => selectTime(closingTimeController),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(onPressed: () => pickImage(true), child: Text(" Choose yhe business license")),
                SizedBox(width: 10),
                _licenseImage != null ? Icon(Icons.check_circle, color: Colors.green) : SizedBox(),
              ],
            ), SizedBox(height: 20,),
            Row(
              children: [
                ElevatedButton(onPressed: () => pickImage(false), child: Text(" Choose the clinc image")),
                SizedBox(width: 10),
                _clinicImage != null ? Icon(Icons.check_circle, color: Colors.green) : SizedBox(),
              ],
            ), SizedBox(height: 20,),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) => mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: LatLng(24.7136, 46.6753), // الرياض كموقع افتراضي
                  zoom: 10,
                ),
                markers: selectedMarker != null ? {selectedMarker!} : {},
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("تحديد موقعي"),
            ),
             SizedBox(height: 20,),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerVet,
              child: Text("تسجيل"),
            ),
          ],
        ),
      ),
    );
  }
}
