import 'package:dio/dio.dart';

abstract class VehicleRemoteDataSource {
  Future<String> getVehicles(); // Il renvoie juste du texte brut
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;

  VehicleRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getVehicles() async {
    try {
      final response = await dio.get(
        'vehicles/getallmakes?format=json',
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
