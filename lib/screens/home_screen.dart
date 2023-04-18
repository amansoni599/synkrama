import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signin_signup/provider/sign_in_provider.dart';
import 'package:signin_signup/screens/login_screen.dart';
import 'package:signin_signup/utils/next__screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Reference storageRef = FirebaseStorage.instance.ref();
  final user = FirebaseAuth.instance.currentUser;
  // final postsRef = FirebaseFirestore.instance.collection('userposts');
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // change read to watch!!!
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  logout(context);
                },
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                ),
                title: const Text("Sign Out"),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("HomeScreen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 45,
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent[100],
                  radius: 45,
                  child: CircleAvatar(
                    backgroundImage: sp.imageUrl == null
                        ? const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png")
                        : NetworkImage("${sp.imageUrl}"), //NetworkImage
                    radius: 45,
                  ), //CircleAvatar
                ), //CircleAvatar
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                sp.name == null ? "Welcome New User" : "Welcome ${sp.name}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(sp.email == null ? "${loggedInUser.email}" : "${sp.email}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15,
              ),
              Text(sp.name == null ? " " : " PROVIDER : ${sp.provider}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15,
              ),
              ActionChip(
                backgroundColor: Colors.lightBlue,
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  logout(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    nextScreen(context, const LoginScreen());
    await FirebaseAuth.instance.signOut();
  }
}
