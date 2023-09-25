import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_form/home/cubit/home_cubit.dart';

enum Approval { approved, denied, none }

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

  Route<void> route() => MaterialPageRoute(
        builder: (context) => const InspectionPage(),
      );

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  final _dateController = TextEditingController();
  final _segmentNotifier = ValueNotifier(Approval.none);

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().createInspection();
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    if (picked != null && mounted) {
      final timestamp = Timestamp.fromDate(picked);
      context.read<HomeCubit>().updateValue('date', timestamp);
      _dateController.text = picked.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspection = context.select((HomeCubit cubit) => cubit.state.newInspection);

    if (inspection == null) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Inspection',
        ),
        leading: BackButton(
          onPressed: () {
            context.read<HomeCubit>().resetInspection();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              onChanged: (value) => context.read<HomeCubit>().updateValue('name', value),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text('Date'),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDatePicker(),
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            ValueListenableBuilder(
              valueListenable: _segmentNotifier,
              builder: (context, approval, child) {
                return SegmentedButton<Approval>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: Approval.approved,
                      label: Text('Approved'),
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                    ButtonSegment(
                      value: Approval.none,
                      label: Text('None'),
                    ),
                    ButtonSegment(
                      value: Approval.denied,
                      label: Text('Denied'),
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ],
                  onSelectionChanged: (newSelection) {
                    _segmentNotifier.value = newSelection.first;
                  },
                  selected: {
                    approval,
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: _segmentNotifier,
              builder: (context, approval, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: approval == Approval.none
                        ? null
                        : () {
                            final approved = approval == Approval.approved;
                            context.read<HomeCubit>().updateValue('approved', approved);
                            Navigator.pop(context);
                          },
                    child: const Text('Submit Inspection'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
