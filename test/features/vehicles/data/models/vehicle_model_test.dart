import 'package:flutter_test/flutter_test.dart';
import 'package:test_technique/features/vehicles/data/models/vehicle_model.dart';
import 'package:test_technique/features/vehicles/domain/entities/vehicle.dart';

void main() {
  // 1. On prépare une fausse donnée (MOCK)
  const tVehicleModel = VehicleModel(makeId: 474, makeName: 'HONDA');

  // Test 1 : Vérifier l'architecture
  test(
    'Doit être une sous-classe de l\'entité Vehicle (Clean Architecture)',
    () async {
      expect(tVehicleModel, isA<Vehicle>());
    },
  );

  // Test 2 : Vérifier le parsing
  group('fromJson', () {
    test(
      'Doit retourner un modèle valide à partir du JSON de l\'API',
      () async {
        // Arrange : On simule un bout de JSON reçu par l'API NHTSA
        final Map<String, dynamic> jsonMap = {
          "Make_ID": 474,
          "Make_Name": "HONDA",
        };

        // Act : On lance notre fonction
        final result = VehicleModel.fromJson(jsonMap);

        // Assert : On vérifie que le résultat correspond au modèle parfait
        expect(result, tVehicleModel);
      },
    );
  });
}
