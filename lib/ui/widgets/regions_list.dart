import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:geodb_cities/cubit/regions_cubit.dart';
import 'package:geodb_cities/cubit/regions_state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';

import 'package:geodb_cities/data/models/regions.dart';

class RegionsList extends ConsumerWidget {
  const RegionsList({Key? key}) : super(key: key);

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
            return FormBuilderDropdown(
              name: 'id_region',
              decoration: InputDecoration(
                labelText: 'Область:',
              ),
              initialValue: null,
              allowClear: false,
              hint: Text("Оберіть область"),
              items: listItems,
              onChanged: (String? value) {
                if (value != null && value != '') {
                  Timer(const Duration(milliseconds: 1000), () {
                    final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                    citiesCubit.clearCities();
                    ref.read(addressDataProvider.notifier).updateRegionId(value);
                    citiesCubit.fetchCities(lang: 'ru', searchValue: '', countryCode: addressData.contryCode.toString(), regionCode: value);
                  });
                }
              },
              menuMaxHeight: 300,
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
