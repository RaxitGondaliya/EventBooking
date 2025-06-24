import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentProfileImage;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentProfileImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController collegeController;
  String selectedGender = "";

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    phoneController = TextEditingController();
    collegeController = TextEditingController();
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    collegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 6),
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          selectedImage != null
                              ? Image.file(
                                selectedImage!,
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                              )
                              : Image.network(
                                widget.currentProfileImage,
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                _buildLabel("Name"),
                SizedBox(height: 10.0),
                _buildTextField(nameController, "Enter Your Name"),
                SizedBox(height: 20.0),
                _buildLabel("Email"),
                SizedBox(height: 10.0),
                _buildTextField(emailController, "Enter Your Email"),
                SizedBox(height: 20.0),
                _buildLabel("Phone Number"),
                SizedBox(height: 10.0),
                _buildTextField(phoneController, "Enter Phone Number"),
                SizedBox(height: 20.0),
                _buildLabel("College / Department"),
                SizedBox(height: 10.0),
                _buildTextField(
                  collegeController,
                  "Enter College or Department",
                ),
                SizedBox(height: 20.0),
                _buildLabel("Gender"),
                SizedBox(height: 10.0),
                _buildGenderDropdown(),
                SizedBox(height: 20.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to change password screen
                    },
                    child: Text("Change Password"),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, {
                        'name': nameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'college': collegeController.text,
                        'gender': selectedGender,
                        'image':
                            selectedImage?.path ?? widget.currentProfileImage,
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    const genders = ["Male", "Female", "Other"];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("Select Gender"),
          value: selectedGender.isEmpty ? null : selectedGender,
          items:
              genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
          onChanged: (val) => setState(() => selectedGender = val ?? ""),
        ),
      ),
    );
  }
}
