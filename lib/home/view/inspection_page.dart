import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_form/home/cubit/home_cubit.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

  Route<void> route() => MaterialPageRoute(
        builder: (context) => const InspectionPage(),
      );

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().createInspection();
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
      ),
      body: const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'Form Here...',
            ),
          ],
        ),
      ),
    );
  }
}
