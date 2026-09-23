import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/food.dart';
import 'package:petcare2/view/homeowner.dart';

class Products extends StatefulWidget{
  @override
  State <Products> createState() => _productsState();
}

class _productsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
     /*double mdw =MediaQuery.of(context).size.width;*/
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
          titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto",fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Homeowner();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),
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
                  width: 150,
                  height: 150,
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
                  width: 150,
                  height: 150,
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
                
                 ElevatedButton(onPressed: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Food();
            }));
                 }, 
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
                  width: 150,
                  height: 150,
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
                  width: 150,
                  height: 150,
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
                        