import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({Key? key}) : super(key: key);

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database update'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('users')
                      .doc('new-guy');

                  // update fields

                  docUser.update({
                    'name': 'kenneth',
                  });
                },
                child: const Text('Update data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
