import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_event.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_state.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  // Le contrôleur qui va écouter le défilement
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // On lance le téléchargement initial dès que la page s'ouvre
    context.read<VehicleBloc>().add(LoadVehicles());

    // On accroche notre écouteur de défilement
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Si on est presque en bas de l'écran (à 200 pixels près), on demande la suite !
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<VehicleBloc>().add(LoadMoreVehicles());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // La fonction de recherche avec Debounce
  void _onSearchChanged(String query) {
    // Si l'utilisateur re-tape une lettre avant 500ms, on annule le timer précédent
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // On relance un timer de 500ms. Si l'utilisateur ne tape rien pendant 500ms,
    // on envoie ENFIN l'événement au BLoC.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<VehicleBloc>().add(SearchVehicles(query: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Véhicules NHTSA'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged, // On branche notre fonction ici !
              decoration: InputDecoration(
                hintText: 'Rechercher une marque...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      // BlocBuilder réagit aux changements d'état de notre BLoC
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading || state is VehicleInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VehicleEmpty) {
            return const Center(child: Text('Aucun véhicule trouvé.'));
          }

          if (state is VehicleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    // Bouton Retry !
                    onPressed: () =>
                        context.read<VehicleBloc>().add(LoadVehicles()),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is VehicleLoaded) {
            return ListView.builder(
              controller: _scrollController,
              // Si on charge la suite, on triche en disant à la liste qu'il y a 1 élément en plus
              // pour avoir la place d'afficher le chargeur en bas
              itemCount: state.vehicles.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Si l'index est égal à la taille de la liste, c'est la "fausse" case de la fin
                if (index >= state.vehicles.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final vehicle = state.vehicles[index];

                // On utilise 'const' pour une haute performance (pas de re-rendu)
                // Dans la réalité de ce code, on pourrait extraire ça dans un VehicleItemWidget
                return ListTile(
                  title: Text(vehicle.makeName),
                  subtitle: Text('ID: ${vehicle.makeId}'),
                  leading: const Icon(Icons.directions_car),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
