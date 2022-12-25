abstract class CountriesState {}

class CountriesEmptyState extends CountriesState {}

class CountriesLoadingState extends CountriesState {}

class CountriesLoadedState extends CountriesState {
  List<dynamic> loadedCountires;
  CountriesLoadedState({required this.loadedCountires});
}

class CountriesErrorState extends CountriesState {}