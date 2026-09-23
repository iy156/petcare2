import 'package:flutter/material.dart';
import 'package:petcare2/app/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:petcare2/view/regdog.dart';
class Addanimal extends StatefulWidget{
  @override
  State<Addanimal> createState() => _addanimalState();}
  
  class _addanimalState extends State<Addanimal> {
  
  
  Widget build(BuildContext context) {
    double mdw =MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("add"),
        titleTextStyle: TextStyle(color: AppColors.c5,fontSize: 20.sp,fontFamily: "Roboto",fontWeight: FontWeight.w700),
       backgroundColor: AppColors.c1,
       leading: IconButton(onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                    return Home();
                    }
                    )
                    ); }
       , icon: Icon(Icons.arrow_back)),
      ),
    body:
    Container(
        width: mdw ,
        child: 
      Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
            child: 
            Text("Add a New Animal",
            style: TextStyle(
            color: AppColors.c4,
            fontWeight: FontWeight.w600,
            fontSize: 30.w
             ),),)
        ),
        SizedBox(height: 20),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
          child: 
          Text("Select the type of animal you wish to register :",
          style: TextStyle(
            color: AppColors.c6,
            fontWeight: FontWeight.w500,
            fontSize: 15.w
             ),),),
        ),
         SizedBox(height: 20),
         Wrap(
          direction: Axis.horizontal,
          spacing: 10.0,
          runSpacing: 10.0,
        children: [
       
          ElevatedButton(onPressed: (){},
         child: Text("Cat")
         ,style: ElevatedButton.styleFrom
         (
          textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
          backgroundColor: AppColors.c4,
          shadowColor: AppColors.c4,
         
         ),            
   ),

    ElevatedButton(onPressed: (){}, 
    child: Text("Reptile"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c6,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    )
    ),
     ElevatedButton(onPressed: (){}, 
    child: Text("Fish"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c6,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    )),
     ElevatedButton(onPressed: (){}, 
    child: Text("Monkey"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    
    
    )),
     ElevatedButton(onPressed: (){}, 
    child: Text("Bride"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    
    )),
     ElevatedButton(onPressed: (){
       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Regidog()), // هنا يتم تحديد الصفحة التي تريد الانتقال إليها
    );
     }, 
    child: Text("Dog"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    
    
    )),
     ElevatedButton(onPressed: (){}, 
    child: Text("livesk"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    
    
    )),
     ElevatedButton(onPressed: (){}, 
    child: Text("Hourse"),
    style:ElevatedButton.styleFrom(
    textStyle: TextStyle(color: AppColors.c5,fontSize: 24,fontWeight:FontWeight.w300,fontFamily: "Roboto"),
    backgroundColor: AppColors.c4,
    shadowColor: AppColors.c4,
    
    
    )),

    


   ]
   ),
   
   ]))

   );
  }
  }




   