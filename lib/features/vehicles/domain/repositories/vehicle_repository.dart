import 'package:test_technique/core/error/failures.dart';
import 'package:test_technique/features/vehicles/domain/entities/vehicle.dart';

abstract class VehicleRepository {
  Future<(Failure?, List<Vehicle>?)> getVehicles();
}
