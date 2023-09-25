import 'dart:async';
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
    try {
      final lastUnapproved = await _findLastUnapproved();

      if (lastUnapproved != null) {
        emit(
          state.copyWith(
            newInspection: lastUnapproved,
          ),
        );
      } else {
        final newInspection = await _createAndUploadNewInspection();
        emit(
          state.copyWith(
            newInspection: newInspection,
          ),
        );
      }
    } on Exception catch (error, stackTrace) {
      devtools.log(
        'Error: ',
        error: error,
        stackTrace: stackTrace,
      );
    }
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

  Future<Inspection?> _findLastUnapproved() async {
    final lastUnApprovedInspection = await _inspectionRef.where('approved', isNull: true).get();
    if (lastUnApprovedInspection.docs.isNotEmpty) {
      final inspection = Inspection.fromSnapshot(lastUnApprovedInspection.docs.first);

      return inspection;
    }
    return null;
  }

  Future<Inspection?> _createAndUploadNewInspection() async {
    final completer = Completer<Inspection?>();
    const newInspection = Inspection.empty();
    try {
      _inspectionRef.add(newInspection.toMap()).then(
        (docRef) async {
          devtools.log('New Inspection Added!');
          final response = await docRef.get();
          final inspection = Inspection.fromSnapshot(response);
          devtools.log('Inspection Retrieved: $inspection');
          completer.complete(inspection);
        },
      );
    } on Exception catch (error, stackTrace) {
      devtools.log(
        'Error on _createAndUploadNewInspection: ',
        error: error,
        stackTrace: stackTrace,
      );
      completer.completeError(error);
    }

    return completer.future;
  }
}
