import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VetAppointmentsPage extends StatefulWidget {
  @override
  _VetAppointmentsPageState createState() => _VetAppointmentsPageState();
}

class _VetAppointmentsPageState extends State<VetAppointmentsPage> {
  List appointments = [];
  bool loading = true;
  String? editingId;
  String newDate = '';

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  // لجلب المواعيد
  Future<void> fetchAppointments() async {
    final token = await getToken();  // استخدم الطريقة الخاصة بك للحصول على التوكن
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8082/api/veterinary/vet/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          appointments = data['data']; // تخصيص البيانات للمواعيد
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        print('Error fetching appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() {
        loading = false;
      });
    }
  }

  // تحديث حالة الموعد
  Future<void> updateStatus(String id, String status) async {
    try {
      await http.put(
        Uri.parse('http://localhost:8082/api/veterinary/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );
      fetchAppointments();
    } catch (e) {
      print('Failed to update status: $e');
    }
  }

  // إعادة جدولة الموعد
  void reschedule(Map appointment) {
    setState(() {
      editingId = appointment['_id'];
      newDate = appointment['appointmentDate'].split('T')[0];
    });
  }

  // تأكيد إعادة جدولة الموعد
  Future<void> confirmReschedule(String id) async {
    try {
      await http.put(
        Uri.parse('http://localhost:8082/api/veterinary/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': 'Rescheduled',
          'appointmentDate': newDate,
        }),
      );
      setState(() {
        editingId = null;
      });
      fetchAppointments();
    } catch (e) {
      print('Failed to reschedule: $e');
    }
  }

  // وظيفة للحصول على التوكن (يمكنك تعديل هذه الوظيفة حسب طريقة تخزين التوكن)
  Future<String> getToken() async {
    return 'your_token_here'; // استبدلها بالتوكن الحقيقي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vet Appointments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // للعودة إلى الصفحة السابقة
          },
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Status: ${appt['status']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${appt['appointmentDate']}"),
                        if (editingId == appt['_id'])
                          Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'New Date (YYYY-MM-DD)'),
                                onChanged: (val) {
                                  newDate = val;
                                },
                              ),
                              ElevatedButton(
                                onPressed: () => confirmReschedule(appt['_id']),
                                child: Text("Confirm Reschedule"),
                              ),
                            ],
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Reschedule') {
                          reschedule(appt);
                        } else {
                          updateStatus(appt['_id'], value);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'Completed', child: Text('Mark Completed')),
                        PopupMenuItem(value: 'Cancelled', child: Text('Cancel')),
                        PopupMenuItem(value: 'Reschedule', child: Text('Reschedule')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
