import 'dart:convert';
import 'dart:io';
import 'package:eventbooking/services/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEvent();
}

class _UploadEvent extends State<UploadEvent> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  final List<String> eventCategory = ["MCA", "MBA", "CE"];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 00);

  static const cloudName = 'ds6irznel';
  static const uploadPreset = 'flutter_eventbooking';

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonRes = json.decode(resStr);
      return jsonRes['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
    }
  }

  String formatTimeofDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectedImage != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          selectedImage!,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: getImage,
                        child: Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
              SizedBox(height: 30),
              TextField(controller: namecontroller, decoration: InputDecoration(hintText: "Enter Event Name")),
              SizedBox(height: 10),
              TextField(controller: pricecontroller, decoration: InputDecoration(hintText: "Enter Price")),
              SizedBox(height: 10),
              TextField(controller: locationcontroller, decoration: InputDecoration(hintText: "Enter Location")),
              SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Select Category"),
                value: value,
                items: eventCategory.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => value = val),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(icon: Icon(Icons.calendar_month), onPressed: _pickDate),
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  SizedBox(width: 20),
                  IconButton(icon: Icon(Icons.access_time), onPressed: _pickTime),
                  Text(formatTimeofDay(selectedTime)),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: detailcontroller,
                maxLines: 5,
                decoration: InputDecoration(hintText: "What will be on that event..."),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select image")));
                    return;
                  }

                  String? imageUrl = await uploadImageToCloudinary(selectedImage!);
                  if (imageUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed")));
                    return;
                  }

                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> uploadevent = {
                    "Image": imageUrl,
                    "Name": namecontroller.text,
                    "Price": pricecontroller.text,
                    "Category": value,
                    "Location": locationcontroller.text,
                    "Detail": detailcontroller.text,
                    "Date": DateFormat('yyyy-MM-dd').format(selectedDate),
                    "Time": formatTimeofDay(selectedTime),
                  };

                  await DatabaseMethods().addEvent(uploadevent, id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Event Uploaded Successfully")),
                  );

                  setState(() {
                    namecontroller.clear();
                    pricecontroller.clear();
                    detailcontroller.clear();
                    locationcontroller.clear();
                    selectedImage = null;
                  });
                },
                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(color: Color(0xff6351ec), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("Upload",
                        style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
