import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

class Vet {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String city;
  final double latitude;
  final double longitude;
  String locationAddress;

  Vet({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.locationAddress = 'Unknown Location',
  });
factory Vet.fromJson(Map<String, dynamic> json) {
  return Vet(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    image: json['image'] ?? 'default_image_path', // إضافة قيمة افتراضية
    city: json['city'] ?? json['location']['city'], // تعديل حسب هيكل البيانات الفعلي
    latitude: (json['latitude'] ?? json['location']['latitude']).toDouble(),
    longitude: (json['longitude'] ?? json['location']['longitude']).toDouble(),
  );
}
}

class Registered extends StatefulWidget {
  @override
  _RegisteredState createState() => _RegisteredState();
}

class _RegisteredState extends State<Registered> {
  List<Vet> vets = [];
  List<Vet> filteredVets = [];
  bool loading = true;
  String selectedCity = '';
  List<String> availableCities = [];

  @override
  void initState() {
    super.initState();
    fetchVets();
  }

  Future<void> fetchVets() async {
    try {
    
      final response = await http.get(Uri.parse('http://10.0.2.2:8082/api/veterinary/all-vets'));
      
      if (response.statusCode == 200) {
        List<dynamic> vetsData = json.decode(response.body);

        // تحقق من البيانات
        print('Vet Data: ${response.body}');

        List<Vet> vetsWithAddresses = await Future.wait(vetsData.map((vetData) async {
          Vet vet = Vet.fromJson(vetData);
          
          // معالجة الحالة عندما تكون الإحداثيات غير موجودة
          if (vet.latitude != null && vet.longitude != null) {
            try {
              String address = await getAddressFromCoordinates(vet.latitude, vet.longitude);
              vet.locationAddress = address;
            } catch (e) {
              print('Error getting address: $e');
              vet.locationAddress = 'Unknown Location';
            }
          } else {
            vet.locationAddress = 'Unknown Location';
          }
          
          return vet;
        }).toList());

        setState(() {
          vets = vetsWithAddresses;
          filteredVets = vets;
          availableCities = vets.map((vet) => vet.city).toSet().toList();
        });
      } else {
        throw Exception('Failed to load vets');
      }
    } catch (error) {
      print('Error fetching veterinarians: $error');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['display_name'] ?? 'Unknown Location';
    } else {
      throw Exception('Failed to load address');
    }
  }

  void filterVetsByCity(String? city) {
    setState(() {
      selectedCity = city ?? '';
      if (selectedCity.isEmpty) {
        filteredVets = vets;
      } else {
        filteredVets = vets.where((vet) => vet.city == selectedCity).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأطباء البيطريين'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<String>(
                  value: selectedCity.isEmpty ? null : selectedCity,
                  hint: Text('اختر المدينة'),
                  onChanged: filterVetsByCity,
                  items: ['الكل', ...availableCities].map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredVets.length,
                    itemBuilder: (context, index) {
                      final vet = filteredVets[index];
                      return Card(
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(vet.image),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                vet.name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              'البريد: ${vet.email}',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'الهاتف: ${vet.phone}',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'المدينة: ${vet.city}',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'العنوان: ${vet.locationAddress}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
