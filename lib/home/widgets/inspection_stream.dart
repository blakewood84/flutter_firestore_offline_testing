import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InspectionStream extends StatelessWidget {
  const InspectionStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inspections').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data?.docs;
        final length = docs?.length ?? 0;

        if (docs == null || length == 0) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          itemCount: length,
          itemBuilder: (context, index) {
            final doc = docs.elementAt(index);
            final name = doc.get('name') as String? ?? 'Unknown';
            final approved = doc.get('approved') as bool? ?? false;
            final date = doc.get('date') as Timestamp?;

            return ListTile(
              title: Text(name),
              leading: approved
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
              subtitle: Text(
                date?.toDate().toString() ?? '---',
              ),
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
