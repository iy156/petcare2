import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:mime/mime.dart';
import 'package:petcare2/core/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // خريطة جوجل
import 'package:geolocator/geolocator.dart';
import 'package:petcare2/view/home.dart'; // للحصول على موقع المستخدم

class Rescue extends StatefulWidget {
  @override

  _rescueState createState() => _rescueState();
}

class _rescueState extends State<Rescue> {
  final TextEditingController _animalTypeController = TextEditingController();
  final TextEditingController _timeSeenController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  File? _image;
  File? _video;
  bool showReportForm = true;
  
  LatLng? _currentLocation; // لتخزين الموقع الحالي للمستخدم
  GoogleMapController? _mapController; // للتحكم في الخريطة

  Map<String, dynamic> report = {
    'animalType': '',
    'timeSeen': '',
    'notes': '',
    'imageUrl': null,
    'videoUrl': null,
    'location': {'latitude': 0.0, 'longitude': 0.0}
  };

 Future<void> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      report['location'] = {'latitude': position.latitude, 'longitude': position.longitude};
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation!)); // تحريك الكاميرا إلى الموقع الحالي
  } catch (e) {
    print("Error getting location: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location')));
  }
}
  // دالة لاختيار صورة
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        report['imageUrl'] = _image;
      });
    }
  }

  // دالة لاختيار فيديو
  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
        report['videoUrl'] = _video;
      });
    }
  }

  // دالة لإرسال التقرير
  Future<void> submitReport() async {
  final formData = <String, String>{
    'animalType': report['animalType'],
    'timeSeen': report['timeSeen'],
    'notes': report['notes'],
    'latitude': report['location']['latitude'].toString(),
    'longitude': report['location']['longitude'].toString(),
  };

  try {
    var request = http.MultipartRequest('POST', Uri.parse("https://10ca-138-199-22-106.ngrok-free.app/api/user/report"));
    request.fields.addAll(formData);

    // إضافة الصورة إذا كانت موجودة
    if (report['imageUrl'] != null) {
      var imageBytes = await _image!.readAsBytes();
      var imageMimeType = lookupMimeType(_image!.path);
      request.files.add(http.MultipartFile.fromBytes(
        'imageUrl', // تأكد من أن هذا هو الاسم الصحيح
        imageBytes,
        filename: _image!.path.split('/').last,
        contentType: MediaType.parse(imageMimeType!),
      ));
    }

    // إضافة الفيديو إذا كان موجودًا
    if (report['videoUrl'] != null) {
      var videoBytes = await _video!.readAsBytes();
      var videoMimeType = lookupMimeType(_video!.path);
      request.files.add(http.MultipartFile.fromBytes(
        'videoUrl', // تأكد من أن هذا هو الاسم الصحيح
        videoBytes,
        filename: _video!.path.split('/').last,
        contentType: MediaType.parse(videoMimeType!),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Report submitted successfully!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  showReportForm = false; // لإخفاء نموذج التقرير
                });
                Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
              },
            ),
          ],
        ),
      );
      // يمكن إضافة التقرير إلى قائمة "strayAnimals" هنا أو التعامل معه حسب الحاجة
    } else {
      throw Exception("Failed to submit report");
    }
  } catch (error) {
    print("Error submitting report: $error");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text("Failed to submit report."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
List<Map<String, dynamic>> reports = [];

  Future<void> fetchReports() async {
    try {
      final response = await http.get(Uri.parse("https://10ca-138-199-22-106.ngrok-free.app/api/user/reports"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          reports = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception("Failed to load reports");
      }
    } catch (error) {
      print("Error fetching reports: $error");
    }
  }



  @override
  void initState() {
    super.initState();
     fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit Report"),
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
      body: ListView(
        children: [
      Padding(
        padding: EdgeInsets.all(16.0),
        child: showReportForm
            ? Column(
                children: [
                  TextField(
                    controller: _animalTypeController,
                    decoration: InputDecoration( enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),labelText: "Animal Type"),
                    onChanged: (value) {
                      setState(() {
                        report['animalType'] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: _timeSeenController,
                    decoration: InputDecoration( enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),
                  ),labelText: "Time Seen"),
                    onChanged: (value) {
                      setState(() {
                        report['timeSeen'] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c2,
                      width:2,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c6,
                      width:2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c1,
                      width: 2,
                    )
                  ),
                   errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.c7,
                      width: 2,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.c7),

                  ),labelText: "Notes"),
                    onChanged: (value) {
                      setState(() {
                        report['notes'] = value;
                      });
                    },
                  ),
                  
                      ElevatedButton(
                        onPressed: pickImage,
                        child: Text("Pick Image"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: pickVideo,
                        child: Text("Pick Video"),
                      ),
                   
                  // عرض الخريطة مع الموقع الحالي
                 if (_currentLocation != null)
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId("currentLocation"),
                            position: _currentLocation!,
                          ),
                        },
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                      ),
                    ),

                  // زر لتحديد الموقع
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: Text("Get Current Location"),
                  ),
                  ElevatedButton(
                    onPressed: submitReport,
                    child: Text("Submit Report"),
                  ), 
                  Padding(
  padding: EdgeInsets.all(16.0),
  child: Column(
    children: [
      Text(
        "Previous Reports",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.c1),
      ),
      SizedBox(height: 10),
      reports.isEmpty
          ? Text(
              "No reports available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.c6, width: 2.5),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Animal: ${report['animalType']}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.c1),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Time Seen: ${report['timeSeen']}",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          "Notes: ${report['notes']}",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 5),
                        Row(
                           mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 18),
                            Expanded(
                              child:
                            Text(
                              "(${report['location']['latitude']}, ${report['location']['longitude']})",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),)
                          ],
                        ),
                        if (report['imageUrl'] != null) ...[
                          SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              report['imageUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        ],
                        if (report['videoUrl'] != null) ...[
                          SizedBox(height: 10),
                          Container(
                            height: 150,
                            color: Colors.black12,
                            child: Center(
                              child: Icon(Icons.play_circle_fill, color: Colors.blue, size: 40),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    ],
  ),
)
                ],
              )
            : Center(child: Text("Report Submitted!")),
            
           
      
      ),])
    );
  }
}
