import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/core/colors.dart';

class Healthinformation extends StatelessWidget {
   const Healthinformation ({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
       title: Text('Health information'),
       titleTextStyle: TextStyle(color: AppColors.c5,fontSize: 20.sp,fontFamily:'Roboto',fontWeight: FontWeight.w700),
       leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: 
          Center(
            child: 
          Text( '~~ Cat Health Information ~~', 
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: AppColors.c1))
          )),
          Container(
            color: const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Common Diseases", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.cathealth),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 450,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "-Respiratory infections : Causes sneezing, coughimng and nasal discharge .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6,)),
                   SizedBox(height:8 ),
                   Text(
                  "-Intestinal Worms : May lead to weight loss and diarrhea .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                   Text(
                  "-Fleas and Parasites : Cause itching and hair loss . ",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height: 5,)
                  
                ]))
              ],
            ),
          ),
          Container(
             color: const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Prevention Tips", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.catriv),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 450,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "-Regularly clean the cat and its enviroment .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                   Text(
                  "-Visit the veterinarian periodically for checkups .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                   Text(
                  "-Provide a healthy and balanced diet .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height: 8)
                ]))
              ],
            ),
          ),
           Container(
             color:const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Vaccination Tips", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.catmar),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 450,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "-Cats should be vaainated against viral diseases such as herpesvirus and calicivirus .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                   Text(
                  "-Follow the viccination schedule set by the veterinarian .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                   Text(
                  "-Rabies vaccintation is essential to prevent infection .",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height: 8)
                ]))
              ],
            ),
          ),
SizedBox(height: 10)
          
        ],
      ),
      
          );}}