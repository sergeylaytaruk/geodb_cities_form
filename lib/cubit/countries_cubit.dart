import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/countries_state.dart';
import 'package:geodb_cities/data/repositories/countries_repository.dart';
import 'package:geodb_cities/data/models/countries.dart';


class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepository countriesRepository;

  CountriesCubit(this.countriesRepository) : super(CountriesEmptyState());
  Future<void> fetchCountries({required String lang, required String searchValue}) async {
    try {
      emit(CountriesLoadingState());
      final List<Countries> _loadedCountriesList = await countriesRepository.getAllCountries(lang: lang, searchValue: searchValue);
      emit(CountriesLoadedState(loadedCountires: _loadedCountriesList));
    } catch (_) {
      print(_);
      emit(CountriesErrorState());
    }
  }
  
  Future<void> clearCountries() async {
    emit(CountriesEmptyState());
  }
}