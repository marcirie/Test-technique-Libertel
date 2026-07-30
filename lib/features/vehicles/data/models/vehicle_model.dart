import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({required super.makeId, required super.makeName});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      makeId: json['Make_ID'] as int,
      makeName: json['Make_Name'] as String,
    );
  }
}
