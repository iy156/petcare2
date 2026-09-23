import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VetView extends StatefulWidget {
  @override
  _VetViewState createState() => _VetViewState();
}

class _VetViewState extends State<VetView> {
  List<Map<String, dynamic>> vets = [];
  List<Map<String, dynamic>> filteredVets = [];
  List<String> availableCities = [];
  String selectedCity = '';
  bool loading = true;
  String defaultImage = 'assets/default-profile.png';  // صورة افتراضية

  @override
  void initState() {
    super.initState();
    fetchVets();
  }

  Future<void> fetchVets() async {
    try {
      final response = await http.get(Uri.parse('https://5e19-185-183-34-152.ngrok-free.app/api/veterinary/all-vets'));

      if (response.statusCode == 200) {
        List<dynamic> vetsData = json.decode(response.body);

        // تحويل إحداثيات المواقع إلى عناوين نصية
        for (var vet in vetsData) {
          if (vet['location'] != null && vet['location']['latitude'] != null && vet['location']['longitude'] != null) {
            String address = await getAddressFromCoordinates(vet['location']['latitude'], vet['location']['longitude']);
            vet['locationAddress'] = address;
          } else {
            vet['locationAddress'] = 'Unknown Location';
          }
        }

        setState(() {
          vets = List<Map<String, dynamic>>.from(vetsData);
          filteredVets = vets;

          // استخراج المدن
          Set<String> cities = Set<String>();
          for (var vet in vets) {
            if (vet['location'] != null && vet['location']['city'] != null) {
              cities.add(vet['location']['city']);
            }
          }
          availableCities = cities.toList();
          loading = false;
        });
      } else {
        print('Failed to load vets');
      }
    } catch (e) {
      print('Error fetching veterinarians: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'] ?? 'Unknown Location';
    } else {
      return 'Unknown Location';
    }
  }

  void filterVetsByCity(String city) {
    setState(() {
      selectedCity = city;
      if (selectedCity == '') {
        filteredVets = vets;
      } else {
        filteredVets = vets.where((vet) => vet['location'] != null && vet['location']['city'] == selectedCity).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinarians'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loading = true;
              });
              fetchVets();
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: selectedCity.isEmpty ? null : selectedCity,
                    hint: Text('Select City'),
                    onChanged: (value) {
                      filterVetsByCity(value!);
                    },
                    items: availableCities
                        .map((city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredVets.length,
                    itemBuilder: (context, index) {
                      var vet = filteredVets[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  vet['profilePicture'] ??
                                      'https://5e19-185-183-34-152.ngrok-free.app/150'),  // صورة افتراضية
                              radius: 40,
                            ),
                            SizedBox(height: 8),
                            Text(vet['name'] ?? 'Unknown'),
                            Text(vet['locationAddress'] ?? 'No Address'),
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
