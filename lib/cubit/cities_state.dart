abstract class CitiesState {}

class CitiesEmptyState extends CitiesState {}

class CitiesLoadingState extends CitiesState {}

class CitiesLoadedState extends CitiesState {
  List<dynamic> loadedCities;
  CitiesLoadedState({required this.loadedCities});
}

class CitiesErrorState extends CitiesState {}