# 🚗 NHTSA Vehicles Explorer

Une application Flutter performante développée dans le cadre d'un test technique, permettant d'explorer la base de données des marques de véhicules de la NHTSA (National Highway Traffic Safety Administration).

## ✨ Fonctionnalités Principales

- **Infinite Scroll** : Chargement fluide et optimisé d'une très grande liste (plus de 12 000 éléments) via un système de pagination en mémoire.
- **Recherche en temps réel (Debounce)** : Barre de recherche intégrée avec un système de "Debounce" (500ms) pour éviter de surcharger le processeur lors de la frappe.
- **Offline First (Mise en cache)** : Utilisation de `Hive` pour stocker la réponse de l'API localement. L'application est totalement fonctionnelle même sans connexion internet.
- **Haute Performance (Isolates)** : Le parsing de la gigantesque réponse JSON (12 000 objets) est délégué à un Isolate (via `compute`) pour garantir que l'interface graphique (UI) reste toujours fluide à 60/120 FPS.

## 🏗 Architecture (Clean Architecture)

Le projet suit strictement les principes de la **Clean Architecture** (Feature-First) couplée à **BLoC** pour la gestion d'état, afin de garantir un code testable, maintenable et évolutif.

```text
lib/
├── core/                  # Composants partagés (Erreurs, Réseau, Thème)
├── injection_container.dart # Injection de dépendances (GetIt)
└── features/
    └── vehicles/
        ├── domain/        # Le cœur (Entités, Contrats des Repositories)
        ├── data/          # L'accès aux données (Models, Repositories Impl, Datasources)
        └── presentation/  # L'interface (BLoC, Pages, Widgets)
```

## 🛠 Stack Technique

- **Framework :** Flutter
- **State Management :** `flutter_bloc`
- **Injection de dépendances :** `get_it`
- **Réseau :** `dio`
- **Base de données locale (Cache) :** `hive` & `hive_flutter`
- **Comparaison d'objets :** `equatable`

## 🚀 Installation & Lancement

1. Clonez ce dépôt.
2. Assurez-vous d'avoir Flutter installé (version récente).
3. Installez les dépendances :

   ```bash flutter pub get```

4. Lancez les tests unitaires :

   ```bash flutter test```

5. Lancez l'application :

   ```bash flutter run```

## 🧠 Choix techniques & Optimisations

1. **Pourquoi BLoC ?**
   Bien que Cubit soit suffisant pour des appels simples, BLoC a été choisi pour sa gestion native et puissante des événements (utile pour la pagination) et sa scalabilité.
2. **Pourquoi sauvegarder le Raw JSON dans Hive ?**
   Plutôt que de générer des TypeAdapters complexes avec `build_runner`, la réponse brute (JSON) de l'API est stockée directement. Cela rend le cache extrêmement léger et ultra-rapide en lecture/écriture.
3. **Gestion du `ScrollController` :**
   Isolé dans un `StatefulWidget` pour éviter les fuites de mémoire (via `dispose()`), tout en gardant une séparation stricte avec la logique métier du BLoC.
