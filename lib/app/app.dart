import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/catgroup.dart';
import 'package:petcare2/view/chat.dart';
import 'package:petcare2/view/doctorvie.dart';
import 'package:petcare2/view/food.dart';
import 'package:petcare2/view/foodproducts.dart';
import 'package:petcare2/view/homedoctor.dart';
import 'package:petcare2/view/homeowner.dart';
import 'package:petcare2/view/myanimals.dart';
import 'package:petcare2/view/products.dart';
import 'package:petcare2/view/registered.dart';
import 'package:petcare2/view/rescue.dart';
import 'package:petcare2/view/gallary.dart';
import 'package:petcare2/view/Featured%20breeders.dart';
import 'package:petcare2/view/Health%20information.dart';
import 'package:petcare2/view/Reportanimal.dart';
import 'package:petcare2/view/Store.dart';
import 'package:petcare2/view/addanimal.dart';
import 'package:petcare2/view/cat.dart';
import 'package:petcare2/view/regcat.dart';
import 'package:petcare2/view/entertainment.dart';
import 'package:petcare2/view/home.dart';
import 'package:petcare2/view/login.dart';
import 'package:petcare2/view/regdog.dart';
import 'package:petcare2/view/signup.dart';
import 'package:petcare2/view/signupdoctor.dart';
import 'package:petcare2/view/signupowner.dart';
import 'package:petcare2/view/splashScreen.dart';
import 'package:petcare2/view/vetappointment.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home:Login(),
      theme: ThemeData(
       fontFamily:"Roboto" ,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.c1,
          
        )
      ),
      
      );
      }
    );
  }
}



