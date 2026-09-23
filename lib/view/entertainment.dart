import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:video_player/video_player.dart';

class Entertainment extends StatefulWidget {
  @override
  State<Entertainment> createState() => _EntertainmentState();
}

class _EntertainmentState extends State<Entertainment> {
  File? selectedFile;
  List<String> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  
  }

  // دالة لجلب الفيديوهات من الخادم
  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse('https://d189-212-102-51-89.ngrok-free.app/api/user/videos'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          videos = data.map<String>((video) => video['url'].toString()).toList();
        });
      } else {
        throw Exception("Failed to load videos");
      }
    } catch (error) {
      print("Error loading videos: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // دالة لاختيار الفيديو
  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  // دالة لرفع الفيديو
  Future<void> uploadVideo() async {
    if (selectedFile == null) {
      // إذا لم يتم اختيار فيديو
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a video file")),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/user/videos/upload'),
    );

    // إضافة الفيديو إلى الـ request
    request.files.add(await http.MultipartFile.fromPath('video', selectedFile!.path));

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        // عند رفع الفيديو بنجاح
        var responseBody = await http.Response.fromStream(response);
        var data = jsonDecode(responseBody.body);

        // طباعة body في الكونسول
        print("Response Body: ${responseBody.body}");

        // دمج الرابط النسبي مع الرابط الأساسي
        String baseUrl = 'https://10ca-138-199-22-106.ngrok-free.app';
        String videoUrl = '$baseUrl${data['url']}';

        setState(() {
          // إضافة الفيديو الجديد إلى القائمة
          videos.insert(0, videoUrl); // يتم تعديل هذا بناءً على شكل البيانات التي تأتي من الـ API
        });

        setState(() {
          selectedFile = null; // إعادة تعيين الملف المختار بعد الرفع
        });

        // عرض إشعار بنجاح الرفع
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Video uploaded successfully!")),
        );

        // عرض إشعار "زكاتك"
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("زكاتك: تم رفع الفيديو بنجاح!")),
        );
      } else {
        // إذا فشل الرفع
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload video")),
        );
      }
    } catch (e) {
      print("Error uploading video: $e");

      // عرض إشعار عند حدوث خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading video: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entertainment"),
        titleTextStyle: TextStyle(color: AppColors.c5, fontSize: 20.sp, fontFamily: "Lumanosimo"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "Let's watch some funny animal videos",
              style: TextStyle(color: AppColors.c3, fontSize: 18.sp),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: selectedFile == null ? selectFile : uploadVideo,  
              label: Text(selectedFile == null ? "Select Video" : "Upload Video"),
              icon: Icon(selectedFile == null ? Icons.add : Icons.upload), 
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c4,
                elevation: 5,
                textStyle: TextStyle(fontSize: 18, color: AppColors.c5, fontFamily: "Lumanosimo"),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : videos.isEmpty
                      ? Center(child: Text("No videos available"))
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 16 / 9,
                          ),
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            return VideoWidget(videoUrl: videos[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  VideoWidget({required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    String videoUrl = widget.videoUrl;
    if (!videoUrl.startsWith('http://') && !videoUrl.startsWith('https://')) {
      videoUrl = 'https://10ca-138-199-22-106.ngrok-free.app$videoUrl';
    }

    _controller = VideoPlayerController.network(videoUrl)
  ..initialize().then((_) {
    setState(() {});
  }).catchError((error) {
    print("Error initializing video player: $error");
  });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
