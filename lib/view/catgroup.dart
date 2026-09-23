
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/core/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare2/view/home.dart';

class Catgroup extends StatefulWidget {
  @override
  State<Catgroup> createState() => _catgroupState();
}

class _catgroupState extends State<Catgroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CatGroup'),
        titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto",fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Home();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),),
        body:
         ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: 
          Center(
            child: 
            Column(
              children: [
          Text( 'Different taypes of cat ', 
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: AppColors.c6)),
          Text("living species",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: AppColors.c1)
          )

        ]))),
          Container(
            color: const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Chinchilla", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.chinchilla),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 250,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  " Known for their luxurious, dense fur that resembles that of a Persian. Chinchillas have a calm and affectionate nature. They are ideal for indoor environments. Their silvery-white coats make them especially popular. They require regular grooming due to their thick fur.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6,)),
                   SizedBox(height:8 ),
                   
                  
                ]))
              ],
            ),
          ),
          Container(
             color: const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: const Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Himalayas", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.himalaya),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "A beautiful blend of Persian and Siamese traits. Himalayas have vivid blue eyes and color-pointed fur. They are quiet and gentle, often seeking attention. Their coats are long and silky. They thrive in a calm and stable household",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                 
                ]))
              ],
            ),
          ),
           Container(
             color:const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: const Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Angora", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.angora),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "One of the oldest cat breeds, originally from Turkey. Known for its soft, silky, medium to long coat. Angoras are playful, elegant, and highly intelligent. They are active and enjoy climbing. This breed forms strong bonds with their owners.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
                ]))
              ],
            ),
          ),
          Container(
             color:const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: const Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Shirazi", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.shirazi),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "A Persian variety popular in the Middle East. Characterized by a flat face and expressive eyes. Shirazi cats are known for their calm demeanor. They adapt well to indoor life. Their thick coat requires daily grooming.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
                ]))
              ],
            ),
          ),
          Container(
             color:const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: const Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Siamese", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.siamese),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 450,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Sleek, short-haired cats with a striking appearance. Known for their loud, expressive voices. Siamese cats are intelligent and social. Their blue almond-shaped eyes are a key feature. They enjoy being around people and other pets.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Pharaonic", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.pharaonic),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "An ancient breed revered in Egyptian culture. Often depicted in hieroglyphics and art. They carry a noble and mysterious aura. Their sleek body and large ears are distinctive. Pharaonic cats are agile and alert.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Ragdoll", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.ragdoll),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Named for their tendency to go limp when picked up. Ragdolls are gentle giants with affectionate personalities. They have soft, semi-long hair and blue eyes. Very sociable and easygoing. Perfect for families and multi-pet homes.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Scotch fold", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.scotchfold),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Easily recognized by their unique folded ears. Scotch Folds have round faces and wide eyes. Their temperament is calm and friendly. They enjoy human company and are playful. Their coat can be short or long and comes in many colors.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("British", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.britch),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 250,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Stocky and sturdy with a plush coat. British cats are calm and reserved. They are independent but enjoy gentle companionship. Their round face and thick body are signature traits. They require little grooming due to their dense fur.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("French", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.french),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Sleek and refined with a graceful body. French cats are elegant in both movement and demeanor. They are affectionate but not overly clingy. Known for their long limbs and narrow faces. Adaptable to both city and rural living",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Wild", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.wild),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 250,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "These cats retain physical traits of their wild ancestors. Often more independent and territorial. They may exhibit strong hunting instincts. Their coats are usually patterned or striped. Ideal for experienced cat owners.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Municipality", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.municipality),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Common domestic cats found in urban environments. They vary widely in color and personality. Generally hardy, smart, and adaptable. Often adopted from streets or shelters. They make loyal and low-maintenance companions.",
                   style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
                ]))
              ],
            ),
          ),
          Center(child: 

           Text("Extinct details",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: AppColors.c1)
          ),),

           Container(
             color:const Color.fromARGB(255, 231, 234, 232),
           
            margin:EdgeInsets.all(10),
            
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                child: 
                Text("Smilodon", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.smilodon),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "Also known as the saber-toothed tiger. Lived in the Americas during the Ice Age. Known for its massive fangs and muscular build. Hunted large herbivores like bison. A symbol of prehistoric feline power.",
                   style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
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
                Text("Homotherium", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),)),
                SizedBox(height: 5),
              
                Image(image: AssetImage(AppAssets.homotherium),fit: BoxFit.cover,
                 width: double.infinity, 
            height: 350,  
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child: 
               Column(children: [
                 
               Text(
                  "A scimitar-toothed cat with shorter fangs than Smilodon. Roamed Europe, Asia, and Africa. Adapted for daylight hunting in open areas. Known for its sloped back and long limbs. Extinct over 10,000 years ago.",
                   style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.c6)),
                   SizedBox(height:8 ),
                  
                ]))
              ],
            ),
          ),
SizedBox(height: 10)
          
        ],
      ),
         
    );
}}