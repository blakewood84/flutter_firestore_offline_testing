import 'dart:developer' as devtools;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:offline_form/home/models/inspection.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : _inspectionRef = FirebaseFirestore.instance.collection('inspections'),
        super(
          const HomeState.initial(),
        );

  final CollectionReference<Map<String, dynamic>> _inspectionRef;

  Future<void> createInspection() async {
    const newInspection = Inspection.empty();
    _inspectionRef.add(newInspection.toMap()).then((docRef) async {
      devtools.log('New Inspection Added!');
      final docId = docRef.id;
      devtools.log('DocID: $docId');
      final response = await docRef.get();
      final inspection = Inspection.fromSnapshot(response);
      devtools.log('Inspection Retrieved: $inspection');

      emit(
        state.copyWith(
          newInspection: inspection,
        ),
      );
    });
  }
}
