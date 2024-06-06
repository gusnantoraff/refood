import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uas_project/tabs/login.dart';

class ProfileTab extends StatefulWidget {
  final User? user;
  final VoidCallback onLogout;
  final bool isUserLoggedIn;

  ProfileTab({
    required this.onLogout,
    this.user,
    this.isUserLoggedIn = true,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                widget.isUserLoggedIn ? AssetImage("assets/avatar.jpg") 
                : null,
            child: widget.isUserLoggedIn
                ? null
                : Icon(LineIcons.user, size: 60, color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            widget.user != null && widget.isUserLoggedIn
                ? widget.user!.displayName ?? ""
                : "Guest",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.user != null && widget.isUserLoggedIn
                ? widget.user!.email ?? ""
                : "guest@gmail.com",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 50),

          // Personal Data
          ListTile(
            leading: Icon(LineIcons.user),
            title: Text("Personal Data"),
            trailing: Icon(LineIcons.angleRight),
            onTap: () {
              // TODO: Navigate to personal data screen
            },
          ),
          Divider(),

          // Settings
          ListTile(
            leading: Icon(LineIcons.cog),
            title: Text("Settings"),
            trailing: Icon(LineIcons.angleRight),
            onTap: () {
              // TODO: Navigate to settings screen
            },
          ),
          Divider(),

          // Logout/Sign In Button
          ListTile(
            leading: Icon(LineIcons.doorOpen),
            title: Text(
              widget.isUserLoggedIn ? "Logout" : "Sign In",
              style: TextStyle(
                  color: widget.isUserLoggedIn ? Colors.red : Colors.green),
            ),
            trailing: Icon(LineIcons.angleRight),
            onTap: () async {
              if (widget.isUserLoggedIn) {
                await FirebaseAuth.instance.signOut();
                widget.onLogout();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginTab()),
                );
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
