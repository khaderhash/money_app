import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/Screens/Goaladd.dart';

import '../Screens/GoalEdit.dart';

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
                      backgroundColor: Colors.black,
                      child: Text(
                        accountInitial,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    accountName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    accountEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
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
                  onTap: () => Navigator.pushNamed(context, EditGoalScreen.id),
                ),
                buildListItem(
                  icon: Icons.book,
                  title: 'My Courses',
                  onTap: () => Navigator.pop(context),
                ),
                buildListItem(
                  icon: Icons.workspace_premium,
                  title: 'Go Premium',
                  onTap: () => Navigator.pop(context),
                ),
                buildListItem(
                  icon: Icons.video_label,
                  title: 'Saved Videos',
                  onTap: () => Navigator.pop(context),
                ),
                buildListItem(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),
                buildListItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () => Navigator.pop(context),
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
      leading: Icon(icon, color: color ?? Colors.orange),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
