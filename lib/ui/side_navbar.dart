import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:property_valuation/ui/profile.dart';
import 'package:property_valuation/ui/sale_comparable.dart';


import '../main.dart';
import 'create_case.dart';
import 'dashboard.dart';

late DatabaseReference reference;
class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _signOut() async {
    await _auth.signOut();
  }
  late String fname, email;

  void getProfileData() async {
    await for (var snapshot
    in FirebaseFirestore.instance.collection('Users').snapshots()) {
      for (var message in snapshot.docs) {
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            if (message.get('email') ==
                FirebaseAuth.instance.currentUser!.email) {
              fname = message.get('name');
              email = message.get('email');

            }
          }
          return Drawer(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            fname,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const Flexible(
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.blue),
                  title: Text('Home'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.blue),
                  title: const Text('Create Case'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCase(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.map_outlined, color: Colors.blue),
                  title: Text('Sale Comparable'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SaleComparable(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded, color: Colors.blue),
                  title: const Text('Profile'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.blue),
                  title: Text('Logout'),
                  onTap: () => {
                    _signOut(),
                    Navigator.pop(context),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          title: 'Property Evaluation',
                        ),
                      ),
                    )
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}
