import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class LoadMoreVehicles extends VehicleEvent {}

class SearchVehicles extends VehicleEvent {
  final String query;

  const SearchVehicles({required this.query});

  @override
  List<Object> get props => [query];
}
