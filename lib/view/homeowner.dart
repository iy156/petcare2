import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/cat.dart';
import 'package:petcare2/view/Reportanimal.dart';
import 'package:petcare2/view/Store.dart';
import 'package:petcare2/view/addanimal.dart';
import 'package:petcare2/view/entertainment.dart';
import 'package:petcare2/view/foodproducts.dart';
import 'package:petcare2/view/login.dart';
import 'package:petcare2/view/myanimals.dart';

class Homeowner extends StatefulWidget {
   @override
  State<Homeowner> createState() => _homeownerState();}
  
  class _homeownerState extends State<Homeowner>{ 


  @override
 

  @override
 
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Homeowner'),
       titleTextStyle: TextStyle(color: AppColors.c5,fontSize: 20.sp),
       actions: [
         IconButton(onPressed:(){}, 
         icon: const Icon(Icons.notifications,
         color: AppColors.c5,
         ),)
       ],
       ),
      drawer: Drawer(
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
            title: const Text("My Animal",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.home_sharp,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Myanimals(); }));
            }
            ),

       
           ListTile(
            title: const Text("Registration",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.pets,
            color: AppColors.c4),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Addanimal();
              }));}
            ),
            ListTile(
            title: const Text("Veterinarians",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.person,
            color: AppColors.c4),
            onTap: () {}
            ),
             ListTile(
            title: const Text("Entertainment",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Robote")),
            leading: const Icon(Icons.video_camera_back,
            color: AppColors.c4),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Entertainment();

              }));
            }
            ),

            ListTile(
            title: const Text("Products",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.production_quantity_limits,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Store();

            }));
            }
            ),
            
            ListTile(
            title: const Text("Rescue",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Robote")),
            leading: const Icon(Icons.pets,
            color: AppColors.c4),
            onTap: () {}
            ),
             ListTile(
            title: const Text("Lost",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.location_on_sharp,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Reportanimal(); }));
                 }
            )
            ,
              ListTile(
            title: const Text("Logout",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.logout,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Login();

            }));
            }
            ),

            ]
            )
            ]
            )
            ),
         
    

body:
    Stack(
        children: [
         
          Center(
            child: Wrap(
          direction: Axis.horizontal,
          spacing: 19.0,
          runSpacing: 19.0,
        children: [
                ElevatedButton(onPressed:() {Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Foodproducts();}));},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero
                ),
                 child:Column(
                  children: [
                  Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppAssets.clothes),
                    fit: BoxFit.cover),
                  ),
                 ),
                 Text("Clothes",style: TextStyle(color: AppColors.c1,fontSize: 15,fontWeight: FontWeight.w800),)
                  ]
                 )
                 ),
                SizedBox(width: 10),
                 ElevatedButton(onPressed:  () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Foodproducts();}));
                 }, 
                 style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                   padding: EdgeInsets.zero
                ),
                 child:
                 Column(
                  children: [
                  Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppAssets.split),
                    fit: BoxFit.cover)
                  ),
                 ),
                  Text("Split",style: TextStyle(color: AppColors.c1,fontSize: 15,fontWeight: FontWeight.w800),)
                  ]
                  
                  )
                 ),
                 SizedBox(width: 10),
                
                 ElevatedButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Foodproducts();}));}, 
                 style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                   padding: EdgeInsets.zero
                ),
                 child:Column(
                  children: [
                  Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppAssets.food),
                    fit: BoxFit.cover)
                  ),
                 ),
                  Text("Food",style: TextStyle(color: AppColors.c1,fontSize: 15,fontWeight: FontWeight.w800),)
                  ]
                  
                 )
                 ),
                 SizedBox(width: 10),
                  ElevatedButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Foodproducts();}));}, 
                 style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero
                ),
                 child:
                 Column(
                  children: [
                  Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppAssets.accssoires),
                    fit: BoxFit.cover)
                  ),
                 ),
                  Text("Accsoires",style: TextStyle(color: AppColors.c1,fontSize: 15,fontWeight: FontWeight.w800),)
                  ])
                 )

              ],
            ),
          ),
        ],),
    );
  } 
  }