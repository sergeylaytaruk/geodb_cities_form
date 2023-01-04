import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:geodb_cities/cubit/regions_cubit.dart';
import 'package:geodb_cities/cubit/regions_state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';
import 'package:geodb_cities/ui/widgets/input_border.dart';
import 'package:geodb_cities/data/models/regions.dart';

import 'package:geodb_cities/data/models/regions.dart';

class RegionsList extends ConsumerWidget {
  RegionsList({Key? key}) : super(key: key);

  Timer? timerSearchRegions;
  final _formSelectFieldKey = GlobalKey<FormBuilderFieldState>();

  FocusNode focusRegion  = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressData = ref.watch(addressDataProvider);
    return BlocBuilder<RegionsCubit, RegionsState>(
        builder: (context, state) {
          if (state is RegionsEmptyState) {
            return Center(
              child: Text("No data received."),
            );
          }
          if (state is RegionsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RegionsLoadedState) {
            focusRegion.requestFocus();
            List<DropdownMenuItem<String>> listItems = [];
            state.loadedRegions.forEach((item) {
              listItems.add(
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Text(
                        item.name,
                      ),
                    ],
                  ),
                  value: item.isoCode.toString(),
                ),
              );
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                addressData.contryCode != null ?
                Expanded(
                  flex: 0,
                  child: BlocBuilder<RegionsCubit, RegionsState>(
                      builder: (context, state) {
                        return TextFormField(
                          focusNode: focusRegion,
                          initialValue: '',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: "Пошук області",
                            isDense: false,
                            enabledBorder: inputDecoration(),
                            focusedBorder: inputDecoration(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          ),
                          onChanged: (value) {
                            timerSearchRegions?.cancel();
                            timerSearchRegions = Timer(const Duration(milliseconds: 1000), () {
                              final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              regionsCubit.clearRegions();
                              citiesCubit.clearCities();
                              regionsCubit.fetchRegions(lang: addressData.lang, searchValue: value, countryCode: addressData.contryCode.toString());
                            });
                          },
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                        );
                      }
                  ),
                ) : Expanded(child: Container(), flex: 0,),
                SizedBox(height: 16,),
                FormBuilderDropdown<String>(
                  key: _formSelectFieldKey,
                  name: 'id_region',
                  decoration: InputDecoration(
                    labelText: 'Область:',
                    isDense: false,
                    enabledBorder: selectDecoration(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formSelectFieldKey.currentState?.reset();
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateRegionId('');
                        ref.read(addressDataProvider.notifier).updateCityId('');
                      },
                    ),
                    hintText: 'Оберіть область:',
                  ),
                  initialValue: addressData.regionId,
                  allowClear: false,
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      Regions region = getSelectedRegion(state, value);
                      ref.read(addressDataProvider.notifier).updateRegion(region);
                      Timer(const Duration(milliseconds: 1000), () {
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateRegionId(value);
                        ref.read(addressDataProvider.notifier).updateCityId('');
                        citiesCubit.fetchCities(lang: addressData.lang, searchValue: '', countryCode: addressData.contryCode.toString(), regionCode: value);
                      });
                    }
                  },
                  menuMaxHeight: 300,
                ),
              ],
            );
          }
          if (state is RegionsErrorState) {
            return Center(
              child: Text("Error loading regions"),
            );
          }
          return SizedBox.shrink();
        }
    );
  }

  Regions getSelectedRegion(state, String regionId) {
    final Regions region = state.loadedRegions.singleWhere((element) =>
    element.isoCode == regionId, orElse: () {
      return Regions(name: '', countryCode: '', isoCode: '');
    });
    return region;
  }
}
