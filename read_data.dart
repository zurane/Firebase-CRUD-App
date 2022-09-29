import 'package:firebase_app/Delete_data.dart';
import 'package:firebase_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/update_data.dart';
import 'package:firebase_app/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ReadData extends StatefulWidget {
  const ReadData({Key? key}) : super(key: key);

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Database'),
      ),
      body: FutureBuilder<User?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user == null
                ? Center(child: Text('User not found!'))
                : buildUser(user);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Text('Firebase App')),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(title: 'All Users')));
              },
            ),
            ListTile(
              title: const Text('Read Database'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ReadData()));
              },
            ),
            ListTile(
              title: const Text('Update Database'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdateData()));
              },
            ),
            ListTile(
              title: const Text('Delete Database'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RemoveData()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<User?> readUser() async {
  // Get single document by id
  final docUser = FirebaseFirestore.instance.collection('users').doc('new-guy');
  final snapshot = await docUser.get();

  if (snapshot.exists) {
    return User.fromJson(snapshot.data()!);
  }
}

Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(child: Text('${user.age}')),
      title: Text(user.name),
      subtitle: Text(user.profession),
    );

Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

Future createUser({required String name}) async {
  final docUser = FirebaseFirestore.instance.collection('user').doc();

  final user =
      User(id: docUser.id, name: name, age: 23, profession: 'designer');

  final json = user.toJson();

  // Create document and write data to firebase

  await docUser.set(json);
}

// This is my User Model Object
class User {
  String id;
  final String name;
  final int age;
  final String profession;

  User(
      {this.id = '',
      required this.name,
      required this.age,
      required this.profession});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'profession': profession,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        profession: json['profession'],
      );
}
