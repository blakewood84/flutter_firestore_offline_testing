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
    final lastUnApprovedInspection = await _inspectionRef.where('approved', isNull: true).get();
    if (lastUnApprovedInspection.docs.isNotEmpty) {
      final inspection = Inspection.fromSnapshot(lastUnApprovedInspection.docs.first);
      emit(
        state.copyWith(
          newInspection: inspection,
        ),
      );
      return;
    }

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

  void resetInspection() => emit(
        state.copyWith(
          newInspection: null,
        ),
      );

  void updateValue(String key, Object? value) {
    _inspectionRef.doc(state.newInspection?.id).update({
      key: value,
    });
  }
}
