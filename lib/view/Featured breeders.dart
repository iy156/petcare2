import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';

class Veterinarians extends StatefulWidget {
  @override
  _VeterinariansState createState() => _VeterinariansState();
}

class _VeterinariansState extends State<Veterinarians> {
  List<VeterinarianModel> veterinarians = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBreeders();
  }

  Future<void> fetchBreeders() async {
    try {
      final response = await http.get(Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/user/breeders'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          veterinarians = data.map((json) => VeterinarianModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        print('Failed to load breeders, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching breeders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Veterinarians'),
        titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Lumanosimo",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return Home();
              }),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: veterinarians.length,
              itemBuilder: (context, index) {
                final vet = veterinarians[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: vet.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vet.name,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("📍 ${vet.location}", style: TextStyle(color: Colors.grey[700])),
                                Text("💼 ${vet.description}", style: TextStyle(color: Colors.grey[700])),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(" ${vet.rating}", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Reviews:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: vet.reviews.isEmpty
                            ? [Text("No reviews available", style: TextStyle(color: Colors.grey))]
                            : vet.reviews.map((review) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text("- ${review.comment}", style: TextStyle(color: Colors.black87)),
                              )).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class VeterinarianModel {
  final String id;
  final String name;
  final String image;
  final String location;
  final String description;
  final double rating;
  final List<Review> reviews;

  VeterinarianModel({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  factory VeterinarianModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = 'https://10ca-138-199-22-106.ngrok-free.app' + (json['image'] ?? '/uploads/default.png');
    print("Image URL: $imageUrl"); // اطبع الرابط للتحقق من صحته
    return VeterinarianModel(
      id: json['_id'],
      name: json['name'],
      image: imageUrl,
      location: json['location'],
      description: json['descripation'] ?? "No description available.",  // Fixed typo here
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['review'] as List<dynamic>?)?.map((r) => Review.fromJson(r)).toList() ?? [],
    );
  }
}

class Review {
  final String userId;
  final String comment;

  Review({
    required this.userId,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      comment: json['comment'] ?? "No text provided",
    );
  }
}
