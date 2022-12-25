import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/cities_state.dart';
import 'package:geodb_cities/data/repositories/cities_repository.dart';
import 'package:geodb_cities/data/models/cities.dart';


class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepository citiesRepository;

  CitiesCubit(this.citiesRepository) : super(CitiesEmptyState());
  Future<void> fetchCities({required String lang, required String searchValue, required String countryCode, required String regionCode}) async {
    try {
      emit(CitiesLoadingState());
      final List<Cities> _loadedCitiesList = await citiesRepository.getAllCities(lang: lang, searchValue: searchValue, countryCode: countryCode, regionCode: regionCode);
      emit(CitiesLoadedState(loadedCities: _loadedCitiesList));
    } catch (_) {
      print(_);
      emit(CitiesErrorState());
    }
  }

  Future<void> clearCities() async {
    emit(CitiesEmptyState());
  }
}