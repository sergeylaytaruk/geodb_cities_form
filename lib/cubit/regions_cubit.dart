import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/regions_state.dart';
import 'package:geodb_cities/data/repositories/regions_repository.dart';
import 'package:geodb_cities/data/models/regions.dart';


class RegionsCubit extends Cubit<RegionsState> {
  final RegionsRepository regionsRepository;

  RegionsCubit(this.regionsRepository) : super(RegionsEmptyState());
  Future<void> fetchRegions({required String lang, required String searchValue, required String countryCode}) async {
    try {
      emit(RegionsLoadingState());
      final List<Regions> _loadedRegionsList = await regionsRepository.getAllRegions(lang: lang, searchValue: searchValue, countryCode: countryCode);
      emit(RegionsLoadedState(loadedRegions: _loadedRegionsList));
    } catch (_) {
      print(_);
      emit(RegionsErrorState());
    }
  }

  Future<void> clearRegions() async {
    emit(RegionsEmptyState());
  }
}