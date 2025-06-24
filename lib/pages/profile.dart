import 'package:eventbooking/pages/edit_profile.dart';
import 'package:eventbooking/pages/signup.dart';
import 'package:eventbooking/services/auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.profileImageUrl,
  });

  static const Color kAccent = Color(0xff6351ec);
  static const List<Color> kGradient = [
    Color(0xffe3e6ff),
    Color(0xfff1f3ff),
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40.0),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: kGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              "My Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      const SizedBox(height: 20),

                      // Name
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Email
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Edit Profile
                      buildProfileOption(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditProfilePage(
                                    currentName: userName,
                                    currentEmail: userEmail,
                                    currentProfileImage: profileImageUrl,
                                  ),
                            ),
                          );

                          if (result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Profile updated")),
                            );
                          }
                        },
                      ),

                      // Logout
                      buildProfileOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () async {
                          await AuthMethod().signOut(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: kAccent),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
