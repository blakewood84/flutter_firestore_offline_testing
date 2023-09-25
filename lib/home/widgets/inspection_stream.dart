import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InspectionStream extends StatelessWidget {
  const InspectionStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inspections').snapshots(),
      builder: (context, snapshot) {
        return ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Title'),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      },
    );
  }
}
