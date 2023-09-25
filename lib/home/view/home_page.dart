import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_form/home/cubit/home_cubit.dart';
import 'package:offline_form/home/view/inspection_page.dart';
import 'package:offline_form/home/widgets/inspection_stream.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Builder(builder: (bContext) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<HomeCubit>(bContext),
                                child: const InspectionPage(),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Create New Inspection',
                          ),
                        ),
                      );
                    }),
                    const Expanded(
                      child: InspectionStream(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
