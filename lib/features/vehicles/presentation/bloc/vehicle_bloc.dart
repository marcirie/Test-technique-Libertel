import 'package:test_technique/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_event.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;

  List<Vehicle> _masterList = [];
  List<Vehicle> _currentList = [];

  final int _pageSize = 30;

  VehicleBloc({required this.repository}) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<LoadMoreVehicles>(_onLoadMoreVehicles);
    on<SearchVehicles>(_onSearchVehicles);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    // État: Initial Loading
    emit(VehicleLoading());
    final (failure, vehicles) = await repository.getVehicles();
    if (failure != null) {
      // État: Error
      emit(VehicleError(message: failure.message));
    } else if (vehicles == null || vehicles.isEmpty) {
      // État: Empty
      emit(VehicleEmpty());
    } else {
      // Succès ! On sauvegarde tout en mémoire (instantané et léger)
      _masterList = vehicles;

      // On découpe juste les 30 premiers pour l'affichage initial
      final firstPage = _masterList.take(_pageSize).toList();
      // État: Loaded
      emit(VehicleLoaded(vehicles: firstPage));
    }
  }

  void _onSearchVehicles(SearchVehicles event, Emitter<VehicleState> emit) {
    // On vérifie juste qu'on a bien téléchargé les données.
    // Même si on est dans l'état VehicleEmpty, on peut quand même faire une nouvelle recherche !
    if (_masterList.isEmpty) return;

    final query = event.query.trim().toLowerCase();

    // Si on efface la recherche, on remet tout
    if (query.isEmpty) {
      _currentList = _masterList;
    } else {
      // Sinon, on filtre (très rapide car ça se passe en mémoire)
      _currentList = _masterList
          .where((v) => v.makeName.toLowerCase().contains(query))
          .toList();
    }

    if (_currentList.isEmpty) {
      emit(VehicleEmpty());
    } else {
      // On affiche les 30 premiers résultats de la nouvelle recherche
      final firstPage = _currentList.take(_pageSize).toList();
      emit(
        VehicleLoaded(
          vehicles: firstPage,
          isLastPage: firstPage.length == _currentList.length,
        ),
      );
    }
  }

  void _onLoadMoreVehicles(LoadMoreVehicles event, Emitter<VehicleState> emit) {
    // Si on n'est pas dans l'état Loaded (ex: on est en erreur), on ne peut pas scroller.
    if (state is! VehicleLoaded) return;

    final currentState = state as VehicleLoaded;

    // Si on a déjà tout affiché ou qu'on est déjà en train de charger, on stoppe.
    if (currentState.isLastPage || currentState.isLoadingMore) return;
    // On émet le même état mais en activant le petit loader du bas (Loading More)
    emit(currentState.copyWith(isLoadingMore: true));
    final currentLength = currentState.vehicles.length;
    final nextLimit = currentLength + _pageSize;
    // Si la prochaine page dépasse les 12000 éléments, on bloque au maximum
    if (nextLimit >= _masterList.length) {
      emit(
        currentState.copyWith(
          vehicles: _masterList,
          isLoadingMore: false,
          isLastPage: true,
        ),
      );
    } else {
      // Sinon, on prend la tranche suivante (ex: de 0 à 100)
      final nextVehicles = _masterList.sublist(0, nextLimit);
      emit(
        currentState.copyWith(
          vehicles: nextVehicles,
          isLoadingMore: false,
          isLastPage: false,
        ),
      );
    }
  }
}
