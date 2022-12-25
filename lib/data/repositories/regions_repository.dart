import 'package:geodb_cities/data/models/regions.dart';
import 'package:geodb_cities/data/services/countries_api_provider.dart';

class RegionsRepository {
  final CountriesProvider _countriesProvider = CountriesProvider();
  Future<List<Regions>> getAllRegions({required String lang, required String searchValue, required String countryCode})
    => _countriesProvider.getRegions(lang, searchValue, countryCode);
}