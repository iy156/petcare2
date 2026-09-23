import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/Reportanimal.dart';
import 'package:petcare2/view/Store.dart';
import 'package:petcare2/view/addanimal.dart';
import 'package:petcare2/view/chat.dart';
import 'package:petcare2/view/entertainment.dart';
import 'package:petcare2/view/login.dart';
import 'package:petcare2/view/myanimals.dart';
import 'package:petcare2/view/registered.dart';
import 'package:petcare2/view/vetappointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Homedoctor extends StatefulWidget {
  @override
  _HomedoctorState createState() => _HomedoctorState();
}

class _HomedoctorState extends State<Homedoctor> {
  TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;
  bool _isLoading = false;
  String? _message;
  List<Map<String, dynamic>> _posts = [];
  late VideoPlayerController _videoPlayerController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _pickImageOrVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); 
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery); 

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    } else if (pickedVideo != null) {
      setState(() {
        _selectedFile = File(pickedVideo.path);
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _submitPost() async {
    final description = _descriptionController.text;
    if (description.isEmpty) {
      setState(() => _message = 'Please enter a description');
      return;
    }

    final token = await _getToken();
    if (token == null) {
      setState(() => _message = 'Please log in first');
      return;
    }

    setState(() => _isLoading = true);

    final uri = Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/veterinary/post-case');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['description'] = description;

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Status posted successfully';
          _descriptionController.clear();
        });
        _fetchPosts();
      } else {
        setState(() => _message = 'An error occurred while publishing: ${response.body}');
      }
    } catch (e) {
      setState(() => _message = 'An error occurred during the request: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fetchPosts() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://10ca-138-199-22-106.ngrok-free.app/api/veterinary/my-cases'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Get Request Status: ${response.statusCode}');
      print('Get Request Body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _posts = data.map<Map<String, dynamic>>((e) {
            return {
              'description': e['description'],
              'mediaUrl': 'https://10ca-138-199-22-106.ngrok-free.app${e['mediaUrl']}',
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business')),
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
                // بقية عناصر القائمة الجانبية...
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Medical Cases & Surgeries",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: AppColors.c4),),
              SizedBox(height: 20,),
              if (_message != null)
                Text(_message!, style: TextStyle(color: Colors.red)),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description',border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              _selectedFile != null
                  ? _selectedFile!.path.endsWith('.mp4')
                      ? _isVideoInitialized
                          ? AspectRatio(
                              aspectRatio: _videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController),
                            )
                          : CircularProgressIndicator()
                      : Image.file(_selectedFile!, height: 150)
                  : Text('No image/video selected'),
              TextButton(
                onPressed: _pickImageOrVideo,
                child: Text('Choose an image or video'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPost,
                child: _isLoading ? CircularProgressIndicator() : Text('Post status'),
              ),
              SizedBox(height: 30),
              Divider(),
              Text('Your Posts:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._posts.map((post) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post['mediaUrl'] != null)
                        post['mediaUrl']!.endsWith('.mp4') // تحقق من نوع الملف
                            ? FutureBuilder(
                                future: _initializeVideoPlayer(post['mediaUrl']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio: _videoPlayerController.value.aspectRatio,
                                      child: VideoPlayer(_videoPlayerController),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                })
                            : Image.network(post['mediaUrl'], height: 150, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post['description']),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
