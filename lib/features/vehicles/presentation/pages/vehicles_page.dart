import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_technique/core/theme/app_theme.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_event.dart';
import 'package:test_technique/features/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:test_technique/features/vehicles/presentation/widgets/vehicle_card.dart';
import 'package:test_technique/features/vehicles/presentation/widgets/shimmer_loading.dart';
import 'package:test_technique/features/vehicles/presentation/widgets/empty_state_widget.dart';
import 'package:test_technique/features/vehicles/presentation/widgets/error_state_widget.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  // Le contrôleur qui va écouter le défilement
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounce;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    // On lance le téléchargement initial dès que la page s'ouvre
    context.read<VehicleBloc>().add(LoadVehicles());

    // On accroche notre écouteur de défilement
    _scrollController.addListener(_onScroll);

    // Écouter le focus du champ de recherche pour animer la barre
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
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

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<VehicleBloc>().add(SearchVehicles(query: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryDark,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.accentCyan,
              ),
              child: Icon(
                Icons.directions_car_rounded,
                color: AppTheme.primaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Véhicules NHTSA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Rechercher une marque...',
                prefixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.search_rounded,
                    key: ValueKey(_isSearchFocused),
                    color: _isSearchFocused
                        ? AppTheme.accentCyan
                        : AppTheme.textSecondary,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [_buildBody()],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        // ── Chargement initial ──
        if (state is VehicleLoading || state is VehicleInitial) {
          return const SliverFillRemaining(child: ShimmerLoading());
        }

        // ── État vide ──
        if (state is VehicleEmpty) {
          return const SliverFillRemaining(child: EmptyStateWidget());
        }

        // ── Erreur ──
        if (state is VehicleError) {
          return SliverFillRemaining(
            child: ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<VehicleBloc>().add(LoadVehicles()),
            ),
          );
        }

        // ── Liste chargée ──
        if (state is VehicleLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Loader en bas de la liste
                  if (index >= state.vehicles.length) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.accentCyan,
                          ),
                        ),
                      ),
                    );
                  }

                  final vehicle = state.vehicles[index];
                  return VehicleCard(vehicle: vehicle, index: index);
                },
                childCount:
                    state.vehicles.length + (state.isLoadingMore ? 1 : 0),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
