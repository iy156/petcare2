import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petcare2/view/home.dart';
import 'package:petcare2/view/homedoctor.dart';
import 'package:petcare2/view/homeowner.dart';
import 'package:petcare2/view/signup.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/core/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _loginState();
}

class _loginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;

  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller.forward();
    // لم يعد يتم استدعاء checkLoginStatus هنا حتى لا ينتقل تلقائياً إلى Homeowner
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // دالة مساعدة لإنشاء انتقال Fade مخصص
  Route createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _loginUser();
    } else {
      Fluttertoast.showToast(msg: 'Please fix errors');
    }
  }

  Future<void> _loginUser() async {
    final url =
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/api/veterinary/login/Veterinary');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email, 'password': _password}),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['token'] != null) {
          String token = responseData['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Fluttertoast.showToast(msg: 'Login Successful!');
          
          // الانتقال مباشرة بعد نجاح تسجيل الدخول بدون تأخير
          Navigator.of(context).pushReplacement(createRoute(Homedoctor()));
        } else {
          Fluttertoast.showToast(msg: 'Token not found in response');
        }
      } else {
        Fluttertoast.showToast(msg: responseData['message'] ?? 'Login failed');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something went wrong. Try again later.');
    }
  }
 
  
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(context, createRoute(Homedoctor()));
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(context, createRoute(Login()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
  
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 93, 225, 167),
                    const Color.fromARGB(255, 24, 126, 82),
                    const Color.fromARGB(255, 27, 51, 53)
                  ],
                ),
              ),
              child: Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _transform.value,
                  child: Container(
                    width: size.width * .9,
                    height: size.width * 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 90,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppAssets.logo,
                            height: 150,
                            width: 200,
                          ),
                          component1(
                              Icons.email_outlined,
                              'Email...',
                              false,
                              true,
                              (value) => _email = value),
                          component1(
                              Icons.lock_outline,
                              'Password...',
                              true,
                              false,
                              (value) => _password = value),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              component2('LOGIN', 2.6, _validateAndLogin),
                              SizedBox(width: size.width / 25),
                              Container(
                                width: size.width / 2.6,
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Forgotten password!',
                                    style: TextStyle(
                                        color: AppColors.c6,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Forgotten password! button pressed');
                                      },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(),
                          RichText(
                            text: TextSpan(
                              text: 'Create a new Account',
                              style: TextStyle(
                                  color: AppColors.c6,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacement(
                                      createRoute(Signup()));
                                },
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget component1(IconData icon, String hintText, bool isPassword,
      bool isEmail, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (isEmail &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                  .hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (isPassword && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        onSaved: onSaved,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.c6),
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.c3,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          string,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
