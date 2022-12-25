import 'dart:convert';

import 'package:geodb_cities/data/models/countries.dart';
import 'package:geodb_cities/data/models/regions.dart';
import 'package:geodb_cities/data/models/cities.dart';
import 'package:http/http.dart' as http;

class CountriesProvider {
  final baseEndpoint = "http://geodb-free-service.wirefreethought.com/v1/geo/";

  Future<List<Countries>> getCountries(String languageCode, String namePrefix) async {
    String url = this.baseEndpoint + "countries?languageCode=$languageCode";
    if (namePrefix != '') {
      url += "&namePrefix=$namePrefix";
    }
    url += "&offset=0&limit=10";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic>countriesJson = json.decode(response.body);
      final List<dynamic> countriesList = countriesJson['data'];
      return countriesList.map((json) => Countries.fromJson(json)).toList();
    } else {
      print(response.body);
      throw Exception('Error loading countries');
    }
  }

  Future<List<Regions>> getRegions(String languageCode, String namePrefix, String countryCode) async {
    String url = this.baseEndpoint + "countries/$countryCode/regions?languageCode=$languageCode";
    if (namePrefix != '') {
      url += "&namePrefix=$namePrefix";
    }
    url += "&offset=0&limit=10";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic>tmpJson = json.decode(response.body);
      final List<dynamic> regionsList = tmpJson['data'];
      print(regionsList);
      return regionsList.map((json) => Regions.fromJson(json)).toList();
    } else {
      print(response.body);
      throw Exception('Error loading regions');
    }
  }

  //http://geodb-free-service.wirefreethought.com/v1/geo/countries/UA/regions
  //http://geodb-free-service.wirefreethought.com/v1/geo/countries/UA/regions/12/cities?offset=0&limit=10&type=CITY

  Future<List<Cities>> getCities(String languageCode, String namePrefix, String countryCode, String regionCode) async {
    String url = this.baseEndpoint + "countries/$countryCode/regions/$regionCode/cities?languageCode=$languageCode";
    if (namePrefix != '') {
      url += "&namePrefix=$namePrefix";
    }
    url += "&offset=0&limit=10";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic>tmpJson = json.decode(response.body);
      final List<dynamic> citiesList = tmpJson['data'];
      print(citiesList);
      return citiesList.map((json) => Cities.fromJson(json)).toList();
    } else {
      print(response.body);
      throw Exception('Error loading cities');
    }
  }
}