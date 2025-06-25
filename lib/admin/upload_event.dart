import 'dart:convert';
import 'dart:io';
import 'package:eventbooking/services/admin_database.dart';
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

  final List<String> departmentList = [
    "MCA",
    "MBA",
    "CE",
    "IT",
    "ME",
    "EE",
    "EC",
    "Civil",
    "Chemical",
    "Architecture",
    "BBA",
    "BCA",
    "Physics",
    "Maths",
    "Others",
  ];

  List<String> selectedDepartments = [];
  bool isAllSelected = false;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  bool isUploading = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 00);

  static const cloudName = 'ds6irznel';
  static const uploadPreset = 'flutter_eventbooking';

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

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

  void _showDepartmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempList = List.from(selectedDepartments);

        return AlertDialog(
          title: Text("Select Departments"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: Text("All Departments"),
                      value: isAllSelected,
                      onChanged: (value) {
                        setState(() {
                          isAllSelected = value!;
                          if (isAllSelected) {
                            tempList = List.from(departmentList);
                          } else {
                            tempList.clear();
                          }
                        });
                      },
                    ),
                    Divider(),
                    ...departmentList.map(
                      (dept) => CheckboxListTile(
                        title: Text(dept),
                        value: tempList.contains(dept),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              tempList.add(dept);
                            } else {
                              tempList.remove(dept);
                              isAllSelected = false;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  selectedDepartments = tempList;
                  isAllSelected =
                      selectedDepartments.length == departmentList.length;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 5.5),
                    Text(
                      "Upload Event",
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
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
                            border: Border.all(
                              color: Colors.black45,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
                SizedBox(height: 30.0),

                _buildTextLabel("Event Name"),
                SizedBox(height: 10.0),

                _buildTextField(namecontroller, "Enter Event Name"),
                SizedBox(height: 20.0),

                _buildTextLabel("Price"),
                SizedBox(height: 10.0),

                _buildTextField(pricecontroller, "Enter Price"),
                SizedBox(height: 20.0),

                _buildTextLabel("Event Location"),
                SizedBox(height: 10.0),

                _buildTextField(locationcontroller, "Enter Location"),
                SizedBox(height: 20.0),

                _buildTextLabel("Select Departments"),
                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 60, // same as other fields
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: _showDepartmentDialog,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedDepartments.isEmpty
                            ? "Select Departments"
                            : selectedDepartments.join(', '),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _pickDate,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Color(0xff6351ec),
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('yyyy-MM-dd').format(selectedDate),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Color(0xff6351ec),
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            formatTimeofDay(selectedTime),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                _buildTextLabel("Event Detail"),
                _buildTextField(
                  detailcontroller,
                  "What will be on that event....",
                  maxLines: 5,
                ),
                SizedBox(height: 20.0),
                isUploading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff6351ec),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        if (selectedImage == null ||
                            namecontroller.text.isEmpty ||
                            pricecontroller.text.isEmpty ||
                            locationcontroller.text.isEmpty ||
                            detailcontroller.text.isEmpty ||
                            selectedDepartments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please fill all fields",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => isUploading = true);

                        String? imageUrl = await uploadImageToCloudinary(
                          selectedImage!,
                        );
                        if (imageUrl == null) {
                          setState(() => isUploading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Upload failed")),
                          );
                          return;
                        }

                        String id = randomAlphaNumeric(10);
                        Map<String, dynamic> uploadevent = {
                          "Image": imageUrl,
                          "Name": namecontroller.text,
                          "Price": pricecontroller.text,
                          "Departments": selectedDepartments,
                          "Location": locationcontroller.text,
                          "Detail": detailcontroller.text,
                          "Date": DateFormat('yyyy-MM-dd').format(selectedDate),
                          "Time": formatTimeofDay(selectedTime),
                        };

                        await AdminDatabase().addEvent(uploadevent, id);

                        setState(() {
                          isUploading = false;
                          namecontroller.clear();
                          pricecontroller.clear();
                          detailcontroller.clear();
                          locationcontroller.clear();
                          selectedImage = null;
                          selectedDepartments.clear();
                          isAllSelected = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Event Uploaded Successfully",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          height: 45,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Color(0xff6351ec),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Upload",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
