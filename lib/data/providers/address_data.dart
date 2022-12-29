
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AddressData {
  final String lang;
  final String? contryCode;
  final String? regionId;
  final String? cityId;


//<editor-fold desc="Data Methods">


  const AddressData({
    required this.lang,
    this.contryCode,
    this.regionId,
    this.cityId,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AddressData &&
              runtimeType == other.runtimeType &&
              lang == other.lang &&
              contryCode == other.contryCode &&
              regionId == other.regionId &&
              cityId == other.cityId
          );


  @override
  int get hashCode =>
      lang.hashCode ^
      contryCode.hashCode ^
      regionId.hashCode ^
      cityId.hashCode;


  @override
  String toString() {
    return 'AddressData{' +
        ' lang: $lang,' +
        ' contryCode: $contryCode,' +
        ' regionId: $regionId,' +
        ' cityId: $cityId,' +
        '}';
  }


  AddressData copyWith({
    String? lang,
    String? contryCode,
    String? regionId,
    String? cityId,
  }) {
    return AddressData(
      lang: lang ?? this.lang,
      contryCode: contryCode ?? this.contryCode,
      regionId: regionId ?? this.regionId,
      cityId: cityId ?? this.cityId,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'lang': this.lang,
      'contryCode': this.contryCode,
      'regionId': this.regionId,
      'cityId': this.cityId,
    };
  }

  factory AddressData.fromMap(Map<String, dynamic> map) {
    return AddressData(
      lang: map['lang'] as String,
      contryCode: map['contryCode'] as String,
      regionId: map['regionId'] as String,
      cityId: map['cityId'] as String,
    );
  }


//</editor-fold>
}

class AddressDataNotifier extends StateNotifier<AddressData> {
  //AddressDataNotifier(super.state);
  AddressDataNotifier() : super(AddressData(lang: 'ru'));

  void updateContryCode(String? contryCode) {
    state = state.copyWith(contryCode: contryCode);
  }

  void updateRegionId(String? regionId) {
    state = state.copyWith(regionId: regionId);
  }

  void updateCityId(String? cityId) {
    state = state.copyWith(cityId: cityId);
  }
}