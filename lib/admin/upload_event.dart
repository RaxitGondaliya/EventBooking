import 'dart:io';
import 'package:eventbooking/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart'; // <-- Added for date formatting

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEvent();
}

class _UploadEvent extends State<UploadEvent> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();
  final List<String> eventCategory = ["MCA", "MBA", "CE"];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 00);

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeofDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
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
                        onTap: () {
                          getImage();
                        },
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

                Text(
                  "Event Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Event Name",
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                Text(
                  "Price",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: pricecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Price",
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                Text(
                  "Event Location",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: locationcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Location",
                    ),
                  ),
                ),


                SizedBox(height: 20.0),

                Text(
                  "Selecct Category",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items:
                          eventCategory
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          ((value) => setState(() {
                            this.value = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: Text("Selecct Category"),
                      iconSize: 36,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      value: value,
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                // Date and time picker

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickDate();
                      },
                      child: Icon(
                        Icons.calendar_month,
                        color: Color(0xff6351ec),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 25.0),

                    GestureDetector(
                      onTap: () {
                        _pickTime();
                      },
                      child: Icon(
                        Icons.alarm,
                        color: Color(0xff6351ec),
                        size: 30.0,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      formatTimeofDay(selectedTime),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                Text(
                  "Event Detail",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: detailcontroller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "What will be on that event....",
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                GestureDetector(
                  onTap: () async {
                    String id = randomAlphaNumeric(10);

                    Map<String, dynamic> uploadevent = {
                      "Image": "",
                      "Name": namecontroller.text,
                      "Price": pricecontroller.text,
                      "Category": value,
                      "Location": locationcontroller.text,
                      "Detail": detailcontroller.text,
                      "Date": DateFormat('yyyy-MM-dd').format(selectedDate),
                      "Time": formatTimeofDay(selectedTime), 
                    };
                    await DatabaseMethods().addEvent(uploadevent, id).then((
                      value,
                    ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Event Uploaded Succesfully",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                      setState(() {
                        namecontroller.text = "";
                        pricecontroller.text = "";
                        detailcontroller.text = "";
                        selectedImage = null;
                      });
                    });
                  },
                  child: Center(
                    child: Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 200,
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
}
