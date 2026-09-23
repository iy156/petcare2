import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/core/colors.dart';

class Store extends StatefulWidget{
  @override
  State <Store> createState() => _storeState();
}

class _storeState extends State<Store> {
  @override
  Widget build(BuildContext context) {
     /*double mdw =MediaQuery.of(context).size.width;*/
    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
        titleTextStyle: TextStyle(color: AppColors.c5, fontSize: 20.sp),
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
                ElevatedButton(onPressed:() {},
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
                 ElevatedButton(onPressed:  () {}, 
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
                
                 ElevatedButton(onPressed: () {}, 
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
                  ElevatedButton(onPressed: () {}, 
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
         
        ],
      ),
    );
  }
} 
                        