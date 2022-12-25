
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressData {
  String? contryCode;
  String? regionId;
  String? cityId;
  AddressData({this.contryCode, this.regionId, this.cityId});
}

class AddressDataNotifier extends StateNotifier<AddressData> {
  //AddressDataNotifier(super.state);
  AddressDataNotifier() : super(AddressData());

  void updateContryCode(String? contryCode) {
    state.contryCode = contryCode;
  }

  void updateRegionId(String? regionId) {
    state.regionId = regionId;
  }

  void updateCityId(String? cityId) {
    state.cityId = cityId;
  }
}