abstract class RegionsState {}

class RegionsEmptyState extends RegionsState {}

class RegionsLoadingState extends RegionsState {}

class RegionsLoadedState extends RegionsState {
  List<dynamic> loadedRegions;
  RegionsLoadedState({required this.loadedRegions});
}

class RegionsErrorState extends RegionsState {}