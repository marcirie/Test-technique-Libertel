import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:test_technique/core/error/failures.dart';
import 'package:test_technique/features/vehicles/data/datasources/vehicle_local_datasource.dart';
import 'package:test_technique/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:test_technique/features/vehicles/data/models/vehicle_model.dart';
import 'package:test_technique/features/vehicles/domain/entities/vehicle.dart';
import 'package:test_technique/features/vehicles/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final VehicleLocalDataSource localDataSource;

  VehicleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<(Failure?, List<Vehicle>?)> getVehicles() async {
    String jsonString;

    try {
      // 1. On tente de récupérer le texte brut sur Internet
      jsonString = await remoteDataSource.getVehicles();

      // 2. Succès ! On sauvegarde discrètement dans le cache
      localDataSource.cacheRawJson(jsonString);
    } catch (e) {
      // 3. Échec d'Internet ! On tente de récupérer le texte depuis le cache
      try {
        jsonString = await localDataSource.getCachedRawJson();
      } catch (cacheError) {
        // 4. Pas d'Internet ET pas de cache = Erreur fatale
        return (
          ServerFailure('Aucune connexion et aucun cache disponible.'),
          null,
        );
      }
    }

    // 5. Qu'on ait eu la donnée par le réseau ou le cache, on lance le parsing en arrière-plan
    try {
      final models = await compute(_parseVehicles, jsonString);
      return (null, models);
    } catch (e) {
      return (ServerFailure('Erreur de traitement des données'), null);
    }
  }
}

// On a déplacé la fonction de parsing du Datasource vers le Repository
List<VehicleModel> _parseVehicles(String responseBody) {
  final parsed = jsonDecode(responseBody);
  final List<dynamic> results = parsed['Results'];
  return results.map((json) => VehicleModel.fromJson(json)).toList();
}
