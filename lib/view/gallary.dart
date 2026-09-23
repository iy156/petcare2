import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:petcare2/app/app.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';

class Gallary extends StatefulWidget {
  @override
  _gallaryState createState() => _gallaryState();
}

class _gallaryState extends State<Gallary> {
  XFile? _image;
  List<ImageModel> images = []; // ✅ قائمة لحفظ الصور محليًا

  @override
  void initState() {
    super.initState();
    fetchImages(); // ✅ تحميل الصور عند بدء الشاشة
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://10ca-138-199-22-106.ngrok-free.app/api/cats/photos'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          images = data.map((json) => ImageModel.fromJson(json)).toList();
        });
      } else {
        print('❌ Failed to load images, status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching images: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selected = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, 
    );

    if (selected != null) {
      setState(() {
        _image = selected;
      });

      await uploadImage(File(selected.path)); 
    }
  }
  

  // ✅ دالة رفع الصورة إلى السيرفر
  Future<void> uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/cats/photos'),
      );

      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("✅ Upload Response: $responseBody");

      if (response.statusCode == 201) {
        print("✅ Image uploaded successfully");
        fetchImages(); // ✅ تحديث الصور فورًا بعد رفع الصورة
      } else {
        print("❌ Failed to upload image. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error uploading image: $e");
    }
  }

  // ✅ دالة إبداء الإعجاب بالصورة
  Future<void> likePhoto(int index) async {
    final image = images[index]; // الحصول على الصورة المعينة

    try {
      final response = await http.post(
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/cats/photos/${image.id}/like'),
      );

      if (response.statusCode == 200) {
        setState(() {
          images[index].likes++; // تحديث عدد الإعجابات بعد الضغط
        });
      } else {
        print("❌ Error liking photo: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error liking photo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        titleTextStyle: TextStyle(
            color: AppColors.c5, fontSize: 20.sp, fontFamily: "Lumanosimo"),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Home();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Welcome to the Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: images.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://10ca-138-199-22-106.ngrok-free.app${image.imageUrl}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.grey),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Likes: ${image.likes}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: Colors.red),
                              onPressed: () {
                                likePhoto(index); // ✅ استدعاء دالة like
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _pickImage,
                  backgroundColor: AppColors.c4,
                  child: Icon(Icons.add_a_photo, color: Colors.white, size: 28),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ImageModel {
  final String id;
  final String imageUrl;
  int likes;

  ImageModel({
    required this.id,
    required this.imageUrl,
    required this.likes,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
      id: json['_id'], imageUrl: json['url'], likes: json['likes']);
}
