import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/view/home.dart';
import 'package:flutter/services.dart';
import 'package:petcare2/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _obscurePassword = true;
  final GlobalKey<FormState> formState = GlobalKey();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime dateOfBirth = DateTime.now();
  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
  }

 Future<void> registerUser(BuildContext context, String firstName, String lastName, String phone, String email, String password, DateTime dateOfBirth, LatLng? location) async {
  if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || location == null) {
    showErrorDialog(context, "All fields are required.");
    return;
  }

  String formattedDate = "${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}";

  final Map<String, String> headers = {"Content-Type": "application/json"};
  final body = json.encode({
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'password': password,
    'dateOfBirth': formattedDate,
    'latitude': location.latitude.toString(),
    'longitude': location.longitude.toString(),
  });

  try {
    final response = await http.post(
      Uri.parse('https://d189-212-102-51-89.ngrok-free.app/api/user/signup'),
      headers: headers,
      body: body,
    );

    final responseData = json.decode(response.body);
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      String token = responseData['token']; // Assuming the token is returned in the response
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);  // Save the token locally

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: "Success",
        desc: "Register successfully!",
      ).show();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return Home();
      }));
    } else {
      throw Exception("Failed to register");
    }
  } catch (error) {
    print("Error: $error");
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: "Error",
      desc: "Something went wrong! Error: $error",
    ).show();
  }
}

void showErrorDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    title: "Error",
    desc: message,
    btnOkOnPress: () {},
  ).show();
}

void showSuccessDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    title: "Success",
    desc: message,
    btnOkOnPress: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    },
  ).show();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              Column(
                children: [
                  _buildTextField(controller: _firstNameController, hintText: "First Name", icon: Icons.person),
                  SizedBox(height: 20),
                  _buildTextField(controller: _lastNameController, hintText: "Last Name", icon: Icons.person),
                  SizedBox(height: 20),
                  _buildPhoneTextField(),
                  SizedBox(height: 20),
                  _buildTextField(controller: _emailController, hintText: "Email", icon: Icons.email, keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 20),
                  _buildTextField(controller: _passwordController, hintText: "Password", icon: Icons.lock, obscureText: _obscurePassword, onIconTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildDatePickerField(),
                  ElevatedButton(onPressed: _getCurrentLocation, child: Text("Get Location")),
                  if (_currentLocation != null)
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: _currentLocation!, zoom: 15),
                        markers: {Marker(markerId: MarkerId("currentLocation"), position: _currentLocation!)} ,
                        onMapCreated: (controller) => _mapController = controller,
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formState.currentState?.validate() ?? false) {
                        registerUser(
                          context,
                          _firstNameController.text,
                          _lastNameController.text,
                          _phoneController.text,
                          _emailController.text,
                          _passwordController.text,
                          dateOfBirth,
                          _currentLocation,
                        );
                      }
                    },
                    child: Text("Signup"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Function()? onIconTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: onIconTap != null ? IconButton(icon: Icon(Icons.visibility), onPressed: onIconTap) : null,
        border: OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? "Please enter $hintText" : null,
    );
  }

  
  Widget _buildPhoneTextField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
      decoration: InputDecoration(
        hintText: "Phone",
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your phone number";
        }
        if (value.length < 10) {
          return "Phone number must be at least 10 digits";
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: "${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}"),
      decoration: InputDecoration(
        hintText: "Select Date of Birth",
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: dateOfBirth,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (newDate != null) {
          setState(() {
            dateOfBirth = newDate;
          });
        }
      },
    );
  }
}
