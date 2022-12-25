import 'package:geodb_cities/data/models/countries.dart';
import 'package:geodb_cities/data/services/countries_api_provider.dart';

class CountriesRepository {
  final CountriesProvider _countriesProvider = CountriesProvider();
  Future<List<Countries>> getAllCountries({required String lang, required String searchValue}) => _countriesProvider.getCountries(lang, searchValue);
}