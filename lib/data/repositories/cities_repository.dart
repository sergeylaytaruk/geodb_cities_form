import 'package:geodb_cities/data/models/cities.dart';
import 'package:geodb_cities/data/services/countries_api_provider.dart';

class CitiesRepository {
  final CountriesProvider _countriesProvider = CountriesProvider();
  Future<List<Cities>> getAllCities({required String lang, required String searchValue, required String countryCode, required String regionCode})
  => _countriesProvider.getCities(lang, searchValue, countryCode, regionCode);
}