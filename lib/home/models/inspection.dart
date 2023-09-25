// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Timestamp;
import 'package:flutter/material.dart' show immutable;

@immutable
class Inspection {
  const Inspection({
    required this.id,
    required this.approved,
    required this.date,
    required this.name,
  });

  final bool? approved;
  final Timestamp? date;
  final String? name;
  final String? id;

  const Inspection.empty()
      : id = null,
        approved = null,
        date = null,
        name = null;

  Map<String, dynamic> toMap() => {
        'approved': approved,
        'date': date,
        'name': name,
      };

  factory Inspection.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final approved = data['approved'] as bool?;
    final date = data['date'] as Timestamp?;
    final name = data['name'] as String?;

    return Inspection(
      id: snapshot.id,
      approved: approved,
      date: date,
      name: name,
    );
  }
}
