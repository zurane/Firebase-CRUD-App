import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/Delete_data.dart';
import 'package:firebase_app/read_data.dart';
import 'package:firebase_app/update_data.dart';
import 'package:firebase_app/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDI6y14Dc4kiaZU4V3_4NK-TlASQc2WUs",
      appId: "696091657118",
      messagingSenderId: "696091657118",
      projectId: "fir-app-f1237",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'All users',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All users'),
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add new',
          child: Icon(
            Icons.add,
            semanticLabel: 'Add new',
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserPage()));
          }),
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
                Navigator.pop(context);
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

  Future<User?> readUser() async {
    // Get single document by id
    final docUser =
        FirebaseFirestore.instance.collection('users').doc('new-guy');
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

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc();

    final user =
        User(id: docUser.id, name: name, age: 23, profession: 'designer');

    final json = user.toJson();

    // Create document and write data to firebase

    await docUser.set(json);
  }
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
