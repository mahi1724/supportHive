import 'package:flutter/material.dart';
import 'package:supporthive1/view/sign_in_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF3F2EC),
      child: SafeArea(
        child: Column(
          children: [
            /// ─── HEADER ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  const Icon(Icons.spa, size: 60, color: Color(0xFF2F6B2F)),
                  const SizedBox(height: 8),
                  const Text(
                    "SUPPORTHIVE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F6B2F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Relax, Recharge, Reflect",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            /// ─── USER CARD ──────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF2F6B2F),
                    child: Text(
                      "M",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mahesh",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Wellness Member", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ─── MENU ITEMS ─────────────────────────
            _DrawerItem(
              icon: Icons.home_outlined,
              title: "Home",
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            _DrawerItem(
              icon: Icons.chat_bubble_outline,
              title: "Chat",
              onTap: () {},
            ),

            _DrawerItem(
              icon: Icons.calendar_today_outlined,
              title: "Schedule",
              onTap: () {},
            ),

            _DrawerItem(
              icon: Icons.person_outline,
              title: "Profile",
              onTap: () {},
            ),

            // const Spacer(),
            const Divider(height: 30),

            /// ─── LOGOUT ─────────────────────────────
            // ListTile(
            //   leading: Builder(

            //     builder: (context) => IconButton(
            //       icon: const Icon(Icons.logout_sharp, color: Color.fromARGB(221, 255, 0, 0)),

            //       onPressed: () {
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(builder: (context) => const SignInScreen()),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// ─── Drawer Item Widget ─────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: selected ? const Color(0xFF2F6B2F) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: Icon(icon, color: selected ? Colors.white : Colors.black87),
          title: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
