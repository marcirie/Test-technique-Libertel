import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int makeId;
  final String makeName;

  const Vehicle({
    required this.makeId,
    required this.makeName,
  });

  @override
  List<Object?> get props => [makeId, makeName];
}
