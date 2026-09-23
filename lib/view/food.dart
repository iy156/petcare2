import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/assets.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/homeowner.dart';
import 'package:petcare2/view/products.dart';

class Food extends StatefulWidget{
  @override
  State <Food> createState() => _foodState();
}

class _foodState extends State<Food> {
  @override

  
  List<dynamic> products = []; // لتخزين قائمة المنتجات

  @override
  void initState() {
    super.initState();
    // تحميل المنتجات عند فتح الصفحة
    _fetchProducts();
  }

  // دالة لإضافة منتج عن طريق API
 

  // دالة لعرض المنتجات عن طريق API
  Future<void> _fetchProducts() async {
    final url = 'https://your-api-endpoint.com/products'; // ضع عنوان الـ API الخاص بك
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body); // تخزين قائمة المنتجات
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load products')));
    }
  }


  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Food"),
          titleTextStyle: TextStyle(
          color: AppColors.c5, fontSize: 20.sp, fontFamily: "Roboto",fontWeight: FontWeight.w700
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Products();
            }));
          },
          icon: Icon(Icons.arrow_back)
        ),
      ),


      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقول إدخال البيانات
            
            SizedBox(height: 20),
            // زر إضافة المنتج
            ElevatedButton(
              onPressed: (){},
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            // عرض قائمة المنتجات
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text('Price: \$${product['price']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );}}