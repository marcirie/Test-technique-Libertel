import 'package:get_it/get_it.dart';
import 'package:test_technique/core/network/dio_client.dart';
import 'package:test_technique/features/vehicles/data/datasources/vehicle_local_datasource.dart';
import 'package:test_technique/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:test_technique/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_bloc.dart';

import 'features/vehicles/data/datasources/vehicle_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => DioClient());

  sl.registerLazySingleton<VehicleLocalDataSource>(
    () => VehicleLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerFactory<VehicleBloc>(() => VehicleBloc(repository: sl()));
}
