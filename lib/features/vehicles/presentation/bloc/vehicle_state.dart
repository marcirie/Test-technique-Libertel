import 'package:equatable/equatable.dart';
import 'package:test_technique/features/vehicles/domain/entities/vehicle.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleEmpty extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final bool isLoadingMore;
  final bool isLastPage;

  const VehicleLoaded({
    required this.vehicles,
    this.isLoadingMore = false,
    this.isLastPage = false,
  });

  VehicleLoaded copyWith({
    List<Vehicle>? vehicles,
    bool? isLoadingMore,
    bool? isLastPage,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object> get props => [vehicles, isLoadingMore, isLastPage];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError({required this.message});

  @override
  List<Object> get props => [message];
}
