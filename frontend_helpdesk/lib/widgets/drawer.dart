import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';
import 'package:frontend_helpdesk/widgets/drawer-tile.dart';
import '../constants/api_service.dart';

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Drawer(
      child: Container(
        color: ArgonColors.white,
        child: Column(
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Tambahkan aksi ketika header diketuk
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Header Tapped')));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.85,
                child: SafeArea(
                  bottom: false,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Image.asset("assets/img/41.png"),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                padding: EdgeInsets.only(top: 24, left: 16, right: 16),
                children: [
                  _buildDrawerTile(
                    context,
                    icon: Icons.home,
                    title: "Home",
                    page: '/home',
                    iconColor: ArgonColors.primary,
                  ),
                  _buildDrawerTile(
                    context,
                    icon: Icons.emoji_people_rounded,
                    title: "Profile",
                    page: '/profile',
                    iconColor: ArgonColors.initial,
                  ),
                  DrawerTile(
                    icon: Icons.logout,
                    title: "Logout",
                    iconColor: ArgonColors.error,
                    onTap: () async {
                      try {
                        await apiService.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Logout successful!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/account');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout failed: $e'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      }
                    },
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DrawerTile _buildDrawerTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String page,
      required Color iconColor}) {
    return DrawerTile(
      icon: icon,
      onTap: () {
        if (currentPage != title) {
          Navigator.pushReplacementNamed(context, page);
        }
      },
      iconColor: iconColor,
      title: title,
      isSelected: currentPage == title,
    );
  }
}
