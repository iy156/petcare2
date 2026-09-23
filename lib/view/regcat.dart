import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/colors.dart';
import 'dart:io';

import 'package:petcare2/view/home.dart';

class Regicat extends StatefulWidget {
   
  @override
  State<Regicat> createState()=> _regcatState();}
  
  class _regcatState extends State<Regicat> {
    String  ?_selectedGender;
    DateTime date =DateTime.now();
    DateTime dat1 =DateTime.now();
    DateTime dat2 =DateTime.now();
    DateTime dat3 =DateTime.now();
    DateTime dat4 =DateTime.now();
    GlobalKey<FormState> formstate  =GlobalKey();
    bool show =true;
  XFile? _image; 

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage; 
    });
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('Register'),
       titleTextStyle: TextStyle(color: AppColors.c5,fontSize: 20.sp,fontFamily:"Roboto",fontWeight: FontWeight.w700),
       leading: IconButton(onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                    return Home();
                    }
                    )
                    ); }
       , icon: Icon(Icons.arrow_back)),
      ),
      
      body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(24),
             child:Form(
              key: formstate ,
            child: 
            Column(
              children: [
                
               Text("Register a Cat",
                   style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: AppColors.c4),
                   ),
              SizedBox(height: 25,), 
                  Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Cat Name",style: TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                   validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Cat Name";
                  }
                  if(value.length >20){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),

                  ),
                  hintText: "Enter cat name",
                  hintStyle: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                   
                )),
                
                SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Date Of Brith",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                   validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your birth";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                  hintText: "Enter your cat birth",
                   hintStyle: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                   
                )),
                 SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Breed",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                    TextFormField(
                       validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Breed";
                  }
                  if(value.length >20){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                  hintText: "Enter your cat breed "  ,
                   hintStyle: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                )),


                SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Owner Name",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                    TextFormField(
                       validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Owner Name";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                  hintText: "Enter your owner name",
                   hintStyle: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                   
                )),
                SizedBox(height: 5,),
                const Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Gender",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                Row(
                  children: [
                    Text("Male",style:  TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                ),
                    Radio(value: "male", groupValue: _selectedGender, onChanged:(val)
                    {
                      setState(() {
                        _selectedGender=val ;
                        
                      });
                    }),
                    SizedBox(width: 25,),
                     Text("Female",style:  TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w500,fontSize: 18)
                ),
                    Radio(value: "fmale", groupValue: _selectedGender, onChanged: (val){
                      setState(() {
                        _selectedGender =val ;
                       
                      });
                    })
                  ],
                ),
                SizedBox(height: 15,),
                Align(
                alignment:Alignment.centerLeft,
                  child: Text("Last Calicivirus Vaccine",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                  
                  validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Last Caliciviruis";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                 
                readOnly: true,
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: IconButton(onPressed: ()async {
                      DateTime ? newDate = await showDatePicker(
                        context: context, 
                        initialDate: date,
                        firstDate: DateTime(2000),
                         lastDate: DateTime(2200),
                         );
                         if(newDate == null )
                         return;
                          setState(() {
                         date=newDate;
                         });},
                   icon: Icon( Icons.calendar_today ),),                  
                   enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),

                  ),
                   hintText: "${date.day}/${date.month}/${date.year}",

                ),
                ),
                
                SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Last Rabies Vaccine",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                TextFormField(
                   validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Last  Rabies Vaccine";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                  
                keyboardType: TextInputType.datetime,
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  suffixIcon: IconButton(onPressed: ()async {
                      DateTime ? newDate = await showDatePicker(
                        context: context, 
                        initialDate: dat1,
                        firstDate: DateTime(2000),
                         lastDate: DateTime(2200),
                         );
                         if(newDate == null )
                         return;
                          setState(() {
                         dat1=newDate;
                         });},
                   icon: Icon( Icons.calendar_today ),),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                   hintText: "${dat1.day}/${dat1.month}/${dat1.year}",
                )),
                 SizedBox(height: 15,),
                 Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Last Feline Plague Vaccine",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                    TextFormField(
                       validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Last Feline";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  suffixIcon: IconButton(onPressed: ()async {
                      DateTime ? newDate = await showDatePicker(
                        context: context, 
                        initialDate: dat2,
                        firstDate: DateTime(2000),
                         lastDate: DateTime(2200),
                         );
                         if(newDate == null )
                         return;
                          setState(() {
                         dat2=newDate;
                         });},
                   icon: Icon( Icons.calendar_today ),),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                  hintText: "${dat2.day}/${dat2.month}/${dat2.year}", 
                )),
                SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Last Cancer Vaccine",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                    TextFormField(
                       validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Last Cancer  Vacccine";
                  }
                  if(value.length >40){
                    return"The value cannot be greater than 20";
                  }
                  return null;
                },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  suffixIcon: IconButton(onPressed: ()async {
                      DateTime ? newDate = await showDatePicker(
                        context: context, 
                        initialDate: dat3,
                        firstDate: DateTime(2000),
                         lastDate: DateTime(2200),
                         );
                         if(newDate == null )
                         return;
                          setState(() {
                         dat3=newDate;
                         });},
                   icon: Icon( Icons.calendar_today ),),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                 hintText: "${dat3.day}/${dat3.month}/${dat3.year}",
                )),
                 SizedBox(height: 15,),
                Align(
                  alignment:Alignment.centerLeft,
                  child: Text("Last Deworming Dose",style:  TextStyle(fontSize: 18,color: AppColors.c4,fontWeight: FontWeight.w500)),
                ),
                    TextFormField(
                         validator: (value) {
                  if(value==null || value.isEmpty){
                    return"please enter your Last Deworming";}
                  if(value.length >40){
                    return"The value cannot be greater than 20";}
                  return null; },
                onChanged: (String value){},
                cursorColor: AppColors.c3,
                decoration: InputDecoration(
                  enabled: true,
                  suffixIcon: IconButton(onPressed: ()async {
                      DateTime ? newDate = await showDatePicker(
                        context: context, 
                        initialDate: dat4,
                        firstDate: DateTime(2000),
                         lastDate: DateTime(2200),
                         );
                         if(newDate == null )
                         return;
                          setState(() {
                         dat4=newDate;
                         });},
                   icon: Icon( Icons.calendar_today ),),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),
                  hintText: "${dat4.day}/${dat4.month}/${dat4.year}",
                )),
                 SizedBox(height: 15,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
            ElevatedButton(
              onPressed:_pickImage,
              child:Text("upload image"),
            style:ElevatedButton.styleFrom(
              shape: LinearBorder(bottom: LinearBorderEdge(alignment: 67)),
            textStyle: TextStyle(color: AppColors.c7,fontSize: 17,fontWeight:FontWeight.w600,fontFamily:"Lumanosimo"),
            backgroundColor: AppColors.c4,
            shadowColor: AppColors.c4,
            padding: EdgeInsets.all(10)
            ),
             ),
              _image != null
                ? Image.file(File(_image!.path), height: 200, width: 200)
                : Text('Image not loaded',style: TextStyle(color: AppColors.c3,fontSize:17,fontWeight: FontWeight.w600 ),),
            SizedBox(height: 10),            
              ]
            )
             ),
            SizedBox(height: 10), 
             ElevatedButton(
              onPressed:(){
                if(formstate.currentState!.validate()){
                      print("valid");
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                    return Home();
                   })); }
                      else{
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:Text("Failed to log")),);
                      }  
              },
              child:Text("Submit Report"),
            style:ElevatedButton.styleFrom(
              shape: LinearBorder(bottom: LinearBorderEdge(alignment: 67)),
            textStyle: TextStyle(color: AppColors.c6,fontSize: 18,fontWeight:FontWeight.w600,fontFamily:"Lumanosimo"),
            backgroundColor: AppColors.c4,
            shadowColor: AppColors.c4,),
             ),
             
           
           ] )
             ,)
             ,)
             ]
             )
              );
              }
            

               }