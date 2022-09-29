import 'package:firebase_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerProfession = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: controllerName,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: controllerAge,
              decoration: InputDecoration(
                hintText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: controllerProfession,
              decoration: InputDecoration(
                hintText: 'Profession',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Container(
            height: 40,
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                final user = User(
                  name: controllerName.text,
                  age: int.parse(controllerAge.text),
                  profession: controllerProfession.text,
                );
                createUser(user);
                Navigator.pop(context);
              },
              child: Text(
                'Create',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future createUser(User user) async {
    // Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }

  static User fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        age: json["age"],
        profession: json["profession"],
      );
}
