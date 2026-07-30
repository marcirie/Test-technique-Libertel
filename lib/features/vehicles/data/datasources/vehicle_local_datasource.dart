import 'package:hive/hive.dart';

abstract class VehicleLocalDataSource {
  Future<void> cacheRawJson(String jsonString);
  Future<String> getCachedRawJson();
}

class VehicleLocalDataSourceImpl implements VehicleLocalDataSource {
  // On récupère la boîte qu'on a ouverte dans le main.dart
  final Box box = Hive.box('vehiclesBox');

  @override
  Future<void> cacheRawJson(String jsonString) async {
    // On sauvegarde le JSON brut sous la clé 'CACHED_VEHICLES'
    await box.put('CACHED_VEHICLES', jsonString);
  }

  @override
  Future<String> getCachedRawJson() async {
    // On récupère la donnée
    final jsonString = box.get('CACHED_VEHICLES');
    if (jsonString != null) {
      return jsonString;
    } else {
      throw Exception('Aucun cache disponible');
    }
  }
}
