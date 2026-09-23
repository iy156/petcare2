import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/homeowner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String id;
  final String imageUrl;
  final int quantity;

  Product({required this.id, required this.imageUrl, required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }
}

class Foodproducts extends StatefulWidget {
  @override
  State<Foodproducts> createState() => _FoodproductsState();
}

class _FoodproductsState extends State<Foodproducts> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchUserProducts();
  }

  Future<void> fetchUserProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('Token: $token'); // التحقق من التوكن

    if (token == null || token.isEmpty) {
      print('No token found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/owner/products'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['products'] != null) {
          setState(() {
            products = List<Product>.from(
              data['products'].map((p) => Product.fromJson(p)),
            );
          });
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // عند انتهاء التوكن، جرب تجديده
        print('Token expired or invalid, attempting to refresh...');
        await refreshToken();
      } else {
        print('Failed to fetch products: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      print('No refresh token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/refresh-token'),
        body: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String newToken = data['newToken']; // تأكد من مفتاح الـ JSON الصحيح

        // تخزين التوكن الجديد
        prefs.setString('token', newToken);

        print('Token refreshed successfully');
        fetchUserProducts(); // محاولة جلب المنتجات بعد تجديد التوكن
      } else {
        print('Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while refreshing token: $e');
    }
  }

  // دالة لتحويل عنوان الصورة إلى عنوان كامل
  String fullImageUrl(String imageUrl) {
    if (imageUrl.startsWith("http")) {
      return imageUrl;
    } else {
      // إزالة "file:///" من البداية إن وجدت، ثم إضافة الـ base URL
      String cleanedUrl = imageUrl.replaceFirst(RegExp(r'^file:\/\/\/'), '/');
      return "https://10ca-138-199-22-106.ngrok-free.app" + cleanedUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('منتجاتي'),
        titleTextStyle: TextStyle(
          color: AppColors.c5,
          fontSize: 20.sp,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Homeowner()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ListTile(
                    title: Text('المنتج: ${p.id}'),
                    subtitle: Text('الكمية: ${p.quantity}'),
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        fullImageUrl(p.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
