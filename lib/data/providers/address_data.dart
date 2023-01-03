
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/models/countries.dart';
import 'package:geodb_cities/data/models/regions.dart';
import 'package:geodb_cities/data/models/cities.dart';

@immutable
class AddressData {
  late String lang;
  String? contryCode;
  String? regionId;
  String? cityId;
  Countries country = new Countries(name: '', code: '');
  Regions region = new Regions(name: '', countryCode: '', isoCode: '');
  Cities city = new Cities(id: '', name: '');

//<editor-fold desc="Data Methods">

  AddressData({
    required this.lang,
    this.contryCode,
    this.regionId,
    this.cityId,
    required this.country,
    required this.region,
    required this.city,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressData &&
          runtimeType == other.runtimeType &&
          lang == other.lang &&
          contryCode == other.contryCode &&
          regionId == other.regionId &&
          cityId == other.cityId &&
          country == other.country &&
          region == other.region &&
          city == other.city);

  @override
  int get hashCode =>
      lang.hashCode ^
      contryCode.hashCode ^
      regionId.hashCode ^
      cityId.hashCode ^
      country.hashCode ^
      region.hashCode ^
      city.hashCode;

  @override
  String toString() {
    return 'AddressData{' +
        ' lang: $lang,' +
        ' contryCode: $contryCode,' +
        ' regionId: $regionId,' +
        ' cityId: $cityId,' +
        ' country: $country,' +
        ' region: $region,' +
        ' city: $city,' +
        '}';
  }

  AddressData copyWith({
    String? lang,
    String? contryCode,
    String? regionId,
    String? cityId,
    Countries? country,
    Regions? region,
    Cities? city,
  }) {
    return AddressData(
      lang: lang ?? this.lang,
      contryCode: contryCode == null ? this.contryCode : contryCode == '' ? null : contryCode,
      regionId: regionId == null ? this.regionId : regionId == '' ? null : regionId,
      cityId: cityId == null ? this.cityId : cityId == '' ? null : cityId,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lang': this.lang,
      'contryCode': this.contryCode,
      'regionId': this.regionId,
      'cityId': this.cityId,
      'country': this.country,
      'region': this.region,
      'city': this.city,
    };
  }

  factory AddressData.fromMap(Map<String, dynamic> map) {
    return AddressData(
      lang: map['lang'] as String,
      contryCode: map['contryCode'] as String,
      regionId: map['regionId'] as String,
      cityId: map['cityId'] as String,
      country: map['country'] as Countries,
      region: map['region'] as Regions,
      city: map['city'] as Cities,
    );
  }

//</editor-fold>
}

class AddressDataNotifier extends StateNotifier<AddressData> {
  //AddressDataNotifier(super.state);
  AddressDataNotifier() : super(
      AddressData(
        lang: 'ru',
        country: new Countries(name: '', code: ''),
        region: new Regions(name: '', countryCode: '', isoCode: ''),
        city: new Cities(id: '', name: ''),
      ),
  );

  void updateContryCode(String? contryCode) {
    state = state.copyWith(contryCode: contryCode);
  }

  void updateRegionId(String? regionId) {
    state = state.copyWith(regionId: regionId);
  }

  void updateCityId(String? cityId) {
    state = state.copyWith(cityId: cityId);
  }

  void updateCountry(Countries? country) {
    state = state.copyWith(country: country);
  }

  void updateRegion(Regions? region) {
    state = state.copyWith(region: region);
  }

  void updateCity(Cities? city) {
    state = state.copyWith(city: city);
  }
}