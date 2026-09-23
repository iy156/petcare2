import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/Featured%20breeders.dart';
import 'package:petcare2/view/cat.dart';
import 'package:petcare2/view/Reportanimal.dart';
import 'package:petcare2/view/Store.dart';
import 'package:petcare2/view/addanimal.dart';
import 'package:petcare2/view/catgroup.dart';
import 'package:petcare2/view/chat.dart';
import 'package:petcare2/view/entertainment.dart';
import 'package:petcare2/view/login.dart';
import 'package:petcare2/view/myanimals.dart';
import 'package:petcare2/view/registered.dart';
import 'package:petcare2/view/rescue.dart';

class Home extends StatefulWidget {
   @override
  State<Home> createState() => _homeState();}
  
  class _homeState extends State<Home>{ 
   late Future<List<Image1Model>> futureImages;

  @override
  void initState() {
    super.initState();
  
  }
Future<List<Image1Model>> fetchImages() async {
  final response = await http.get(
    Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/Hoeme/mopail'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    try {
      
      Map<String, dynamic> jsonData = json.decode(response.body);

     
      if (jsonData.containsKey("animalSections") && jsonData["animalSections"] is List) {
        List<dynamic> data = jsonData["animalSections"];

      
        return data.map((item) => Image1Model.fromJson(item)).toList();
      } else {
        throw Exception('Invalid JSON format: "animalSections" not found or not a list');
      }
    } catch (e) {
      throw Exception('Error parsing JSON: $e');
    }
  } else {
    throw Exception('Failed to load images, status code: ${response.statusCode}');
  }
}
 

  @override
 
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Home'),
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Veterinarians();
              }));
            }
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
            title: const Text("Store",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.store,
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Rescue();

            }));
            }
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
            title: const Text("chat",
            style: TextStyle(color: AppColors.c6,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
            leading: const Icon(Icons.location_on_sharp,
            color: AppColors.c4),
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Chat(); }));
                 }
            ),
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
           body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          Expanded( 
            child: FutureBuilder<List<Image1Model>>(
              future: fetchImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No images found'));
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data!.length,
                  
itemBuilder: (context, index) {
  final image = snapshot.data![index];

  return GestureDetector(
    onTap: () {
      
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Catgroup(); 
      }));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: "https://10ca-138-199-22-106.ngrok-free.app${image.imageUrl}",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, image) => Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
              ),
              errorWidget: (context, image, error) => Icon(
                Icons.error_outline, color: Colors.red, size: 40,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            image.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
},
                  );
                }
              },
            ),
          ),
         
        ],
      ),
    );
  }
}

class Image1Model {
  final String label;
  final String imageUrl;
  

  Image1Model({
    required this.label,
    required this.imageUrl,
  
  });

  factory Image1Model.fromJson(Map<String, dynamic> json) =>
      Image1Model(label: json['label'], imageUrl: json['image'],);
}
  