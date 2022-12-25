import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/address_data.dart';

//final addressDataProvider = StateNotifierProvider<AddressDataNotifier, AddressData>((ref) => AddressDataNotifier(AddressData()));
final addressDataProvider = StateNotifierProvider<AddressDataNotifier, AddressData>((ref) => AddressDataNotifier());