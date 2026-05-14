import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Pages/ProfilePage.dart';
import 'package:myapp/Pages/StartUp.dart';
import 'package:myapp/core/theme/app_theme.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return AppBar(title: const Text("No User"));
    }

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("users").doc(user.uid).get(),

      builder: (context, snapshot) {
        String userName = "User";

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          userName = data["name"] ?? "User";
        }

        return AppBar(
          automaticallyImplyLeading: false,

          toolbarHeight: 72,

          elevation: 0,

          backgroundColor: AppColors.background,

          titleSpacing: 16,

          title: Row(
            children: [
              // PREMIUM AVATAR
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: Container(
                  height: 48,
                  width: 48,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffBFDBFE), Color(0xff60A5FA)],

                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(16),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff60A5FA).withOpacity(0.25),

                        blurRadius: 18,

                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : "U",

                      style: GoogleFonts.manrope(
                        fontSize: 24,

                        fontWeight: FontWeight.w800,

                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // TEXT SECTION
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      _getGreeting(),

                      style: GoogleFonts.inter(
                        fontSize: 14,

                        fontWeight: FontWeight.w500,

                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      userName,

                      overflow: TextOverflow.ellipsis,

                      style: GoogleFonts.manrope(
                        fontSize: 20,

                        fontWeight: FontWeight.w800,

                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // SETTINGS BUTTON
              Container(
                height: 44,
                width: 44,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 18,

                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: IconButton(
                  icon: const Icon(Icons.tune_rounded),

                  color: AppColors.primary,

                  iconSize: 22,

                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,

      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            title: const Text("Logout"),

            content: const Text("Are you sure you want to logout?"),

            actions: [
              TextButton(
                child: const Text("Cancel"),

                onPressed: () => Navigator.of(ctx).pop(),
              ),

              TextButton(
                child: const Text("Logout"),

                onPressed: () async {
                  Navigator.of(ctx).pop();

                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const First()),

                    (route) => false,
                  );
                },
              ),
            ],
          ),
    );
  }
}
