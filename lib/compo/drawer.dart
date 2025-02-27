import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myappmoney2/view/Expences.dart';
import 'package:myappmoney2/view/Goals.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../view/Download.dart';
import '../view/EditProfile.dart';
import '../view/Incomes.dart';
import '../view/login.dart';

class DrawerClass extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String accountInitial;

  const DrawerClass({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.accountInitial,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          SafeArea(
            child: DrawerHeader(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/drawer_background.jpg'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFF2e495e),
                      child: Text(
                        accountInitial,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    accountName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    accountEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List Items
          Expanded(
            child: ListView(
              children: [
                buildListItem(
                  icon: Icons.person,
                  title: 'My Profile',
                  onTap: () {
                    Get.to(EditProfile());
                  },
                ),
                buildListItem(
                  icon: Icons.golf_course_sharp,
                  title: 'Goals',
                  onTap: () {
                    Get.to(Goals());
                  },
                ),
                buildListItem(
                  icon: Icons.punch_clock_sharp,
                  title: 'Reminders',
                  onTap: () {
                    Get.toNamed("/ReminderPage");
                  },
                ),
                // buildListItem(
                //   icon: Icons.analytics_outlined,
                //   title: 'Financial analysis',
                //   onTap: () {
                //     Navigator.pushNamed(context, Financialanalysis.id);
                //   },
                // ),
                buildListItem(
                  icon: Icons.person,
                  title: 'Incomes',
                  onTap: () {
                    Get.to(IncomesScreens());
                  },
                ),
                buildListItem(
                  icon: Icons.person,
                  title: 'Expences',
                  onTap: () {
                    Get.to(ExpencesScreens());
                  },
                ),
                buildListItem(
                  icon: Icons.person,
                  title: 'download',
                  onTap: () {
                    Get.to(UploadDataPage());
                  },
                ),

                const Divider(),
                buildListItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () async {
                    // إظهار التنبيه قبل تسجيل الخروج
                    bool? confirmLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Log Out"),
                        content: Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // لا، لا تسجل الخروج
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back();
                              // Navigator.of(context)
                              //     .pop(true); // نعم، سجل الخروج
                              // تنفيذ عملية تسجيل الخروج هنا
                              await logoutUser();
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      ),
                    );

                    // إذا تم التأكيد على تسجيل الخروج، يتم تنفيذ العملية
                    if (confirmLogout == true) {
                      // بعد تسجيل الخروج، قم بالانتقال إلى صفحة تسجيل الدخول
                      Get.toNamed(loginpage.id);
                    }
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Color(0xFF2e495e)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Color(0xFF482F37),
        ),
      ),
      onTap: onTap,
    );
  }
}

Future<void> logoutUser() async {
  var auth = FirebaseAuth.instance;
  await auth.signOut();

  // مسح حالة تسجيل الدخول من SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('isLoggedIn');
}
