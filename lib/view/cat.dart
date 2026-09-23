// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/Health%20information.dart';
import 'package:petcare2/view/gallary.dart';
import 'package:petcare2/view/home.dart';
/*import 'package:google_maps/google_maps.dart';*/

class Cat extends StatefulWidget {
   @override
  State<Cat> createState() => _catState();}
  
  class _catState extends State<Cat>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text('Cat'),
       titleTextStyle: TextStyle(color: AppColors.c5,fontSize: 20.sp,fontFamily: "Roboto",fontWeight: FontWeight.w700),
       leading: IconButton(onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                    return Home();
                    }
                    )
                    ); }
       , icon: Icon(Icons.arrow_back)),
       )
       ,
        endDrawer: Drawer(
        child: ListView(
          children: [
            Column(
             children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.c3,
                child: Text('a'),
              ),
                accountName: Text("aya"), 
                accountEmail: Text("ayakabalan@gmail.com"),
                ),
               

       
          
             ListTile(
            title: const Text("Animal Breeders Guide",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Robote")),
            leading: const Icon(Icons.video_camera_back,
            color: AppColors.c4),
            onTap: () {
             
            }
            ),

            ListTile(
            title: const Text("Chat",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.store,
            color: AppColors.c4),
            onTap: () {
               
            }
            ),
            
            ListTile(
            title: const Text("Gallery",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Robote")),
            leading: const Icon(Icons.pets,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Gallary(); }
                )
                );

            }
            ),
             ListTile(
            title: const Text("Healthinformation",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.location_on_sharp,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Healthinformation(); }
                )
                );
                 }
            )
            ,

            ]
            )
            ]
            )
            ),
       
       
       
       );
  }
    }