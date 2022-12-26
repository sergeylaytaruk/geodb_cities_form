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

class RegionsList extends ConsumerWidget {
  RegionsList({Key? key}) : super(key: key);

  Timer? timerSearchRegions;

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
                        return TextField(
                          decoration: InputDecoration(
                            labelText: "Пошук області",
                            enabledBorder: myInputBorder(),
                            focusedBorder: myInputBorder(),
                          ),
                          onChanged: (value) {
                            timerSearchRegions?.cancel();
                            timerSearchRegions = Timer(const Duration(milliseconds: 1000), () {
                              final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                              regionsCubit.clearRegions();
                              regionsCubit.fetchRegions(lang: addressData.lang, searchValue: value, countryCode: addressData.contryCode.toString());
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              citiesCubit.clearCities();
                            });
                          },
                        );
                      }
                  ),
                ) : Expanded(child: Container(), flex: 0,),
                FormBuilderDropdown(
                  name: 'id_region',
                  decoration: InputDecoration(
                    labelText: 'Оберіть область:',
                  ),
                  initialValue: null,
                  allowClear: false,
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      Timer(const Duration(milliseconds: 1000), () {
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateRegionId(value);
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
}
