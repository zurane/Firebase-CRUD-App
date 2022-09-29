import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveData extends StatefulWidget {
  const RemoveData({Key? key}) : super(key: key);

  @override
  State<RemoveData> createState() => _RemoveDataState();
}

class _RemoveDataState extends State<RemoveData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove data'),
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

                  docUser.update({
                    'name': FieldValue.delete(),
                  });
                },
                child: const Text('Remove data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
