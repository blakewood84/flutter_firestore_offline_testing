part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  const HomeState({
    required this.newInspection,
  });

  final Inspection? newInspection;

  const HomeState.initial() : newInspection = null;

  HomeState copyWith({
    Inspection? newInspection,
  }) {
    return HomeState(
      newInspection: newInspection ?? this.newInspection,
    );
  }

  @override
  List<Object?> get props => [newInspection];
}
