import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Myanimals extends StatefulWidget {
  @override
  _MyanimalsState createState() => _MyanimalsState();
}

class _MyanimalsState extends State<Myanimals> {
  List<dynamic> animals = [];
  bool isLoading = false;
  String? error;
  final String baseUrl = "https://10ca-138-199-22-106.ngrok-free.app";

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  Future<void> fetchAnimals() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          error = "Authorization token missing. Please login.";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/api/user/animals"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          animals = data['animals'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to fetch animals. Try again later.";
          isLoading = false;
        });
      }
    } catch (err) {
      print("Error fetching animals: $err");
      setState(() {
        error = "Failed to fetch animals. Try again later.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animals"),
        titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto", fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Home();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    final animal = animals[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: animal['image'] != null
                            ? CachedNetworkImage(
                                imageUrl: "$baseUrl${animal['image']}",
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.pets, size: 50),
                        title: Text(animal['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type: ${animal['type']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Breed: ${animal['breed']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Gender: ${animal['gender']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Owner: ${animal['owner']['email']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            if (animal['details'] != null) ...[
                              Text("Rabies: ${animal['details']['rabies'] ?? 'N/A'}"),
                              Text("Parvo: ${animal['details']['parvo'] ?? 'N/A'}"),
                              Text("Cancer: ${animal['details']['cancer'] ?? 'N/A'}"),
                              Text("Worms: ${animal['details']['worms'] ?? 'N/A'}"),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}