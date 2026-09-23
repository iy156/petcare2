import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:petcare2/core/colors.dart';
import 'package:petcare2/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  List messages = [];
  File? selectedFile;
  String? token;
  String? userId;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getString('userId');
    setState(() {});
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    if (token == null) return;
    var response = await http.get(
      Uri.parse("https://10ca-138-199-22-106.ngrok-free.app/api/cats/api/chat/messages"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = jsonDecode(response.body)['data'];
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    } else {
      print("فشل في تحميل الرسائل");
    }
  }

  Future<void> sendMessage() async {
    if ((messageController.text.trim().isEmpty && selectedFile == null) || token == null) return;

    var uri = Uri.parse("https://10ca-138-199-22-106.ngrok-free.app/api/cats/api/chat/send");
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = "Bearer $token";

    request.fields['message'] = selectedFile == null ? messageController.text.trim() : '';
    request.fields['type'] = selectedFile == null
        ? 'text'
        : lookupMimeType(selectedFile!.path)?.split('/')[0] ?? 'file';

    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath("file", selectedFile!.path));
    }

    messageController.clear();
    selectedFile = null;

    var response = await request.send();

    if (response.statusCode == 201) {
      var res = await response.stream.bytesToString();
      var data = jsonDecode(res);
      if (mounted) {
        setState(() {
          messages.add(data['data']);
        });
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<VideoPlayerController> _initializeVideoPlayer(String fileUrl) async {
    VideoPlayerController controller = VideoPlayerController.network(fileUrl);
    await controller.initialize();
    controller.setLooping(false);
    controller.setVolume(1.0);
    return controller;
  }

  Widget buildMessageBubble(message) {
    final isUser = message['userId'] == userId;
    final messageText = message['message'] ?? '';
    final timestamp = DateTime.parse(message['timestamp']).toUtc().add(Duration(hours: 3));
    final timeFormatted = DateFormat('hh:mm a').format(timestamp);

    final file = message['file'];
    String? fileUrl;
    if (file != null) {
      fileUrl = "https://10ca-138-199-22-106.ngrok-free.app$file";
    }

    bool isImage = fileUrl != null && (fileUrl.endsWith('.jpg') || fileUrl.endsWith('.png') || fileUrl.endsWith('.jpeg'));
    bool isVideo = fileUrl != null && fileUrl.endsWith('.mp4');

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue[300] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isUser ? Radius.circular(12) : Radius.circular(0),
              bottomRight: isUser ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (messageText.isNotEmpty)
                Text(
                  messageText,
                  style: TextStyle(color: Colors.black),
                ),
              if (isImage)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.network(fileUrl!, width: 200, height: 200, fit: BoxFit.cover),
                ),
              if (isVideo)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: FutureBuilder<VideoPlayerController>(
                    future: _initializeVideoPlayer(fileUrl!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return AspectRatio(
                          aspectRatio: snapshot.data!.value.aspectRatio,
                          child: VideoPlayer(snapshot.data!),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              SizedBox(height: 5),
              Text(
                timeFormatted,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat"),
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
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text("لا توجد رسائل"))
                : ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessageBubble(messages[index]);
                    },
                  ),
          ),
          if (selectedFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("تم اختيار ملف: ${selectedFile!.path.split('/').last}"),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: pickFile,
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "أدخل رسالتك",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
