import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/countries_cubit.dart';
import 'package:geodb_cities/cubit/countries_state.dart';
import 'package:geodb_cities/cubit/regions_cubit.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';
import 'package:geodb_cities/data/models/countries.dart';
import 'package:geodb_cities/ui/widgets/input_border.dart';

class CountriesList extends ConsumerWidget {
  CountriesList({Key? key}) : super(key: key);

  Timer? timerSearchContries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressData = ref.watch(addressDataProvider);
    return BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          if (state is CountriesEmptyState) {
            return Center(
              child: Text("No data received."),
            );
          }
          if (state is CountriesLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CountriesLoadedState) {
            List<DropdownMenuItem<String>> listItems = [];
            state.loadedCountires.forEach((item) {
              listItems.add(
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Text(
                        item.name,
                      ),
                    ],
                  ),
                  value: item.code.toString(),
                ),
              );
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 0,
                  child: BlocBuilder<CountriesCubit, CountriesState>(
                      builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: "Пошук країни",
                            enabledBorder: myInputBorder(),
                            focusedBorder: myInputBorder(),
                          ),
                          onChanged: (value) {
                            timerSearchContries?.cancel();
                            timerSearchContries = Timer(const Duration(milliseconds: 1000), () {
                              final CountriesCubit countriesCubit = context.read<CountriesCubit>();
                              countriesCubit.clearCountries();
                              countriesCubit.fetchCountries(lang: addressData.lang, searchValue: value);
                              final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                              regionsCubit.clearRegions();
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              citiesCubit.clearCities();
                            });
                          },
                        );
                      }
                  ),
                ),
                FormBuilderDropdown(
                  name: 'id_country',
                  decoration: InputDecoration(
                    labelText: 'Оберіть країну:',
                  ),
                  initialValue: null,
                  allowClear: false,
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      Timer(const Duration(milliseconds: 1000), () {
                        final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                        regionsCubit.clearRegions();
                        ref.read(addressDataProvider.notifier).updateContryCode(value);
                        regionsCubit.fetchRegions(lang: addressData.lang, searchValue: '', countryCode: value);
                      });
                    }
                  },
                  menuMaxHeight: 300,
                ),
              ],
            );
          }
          if (state is CountriesErrorState) { // 7:31
            return Center(
              child: Text("Error loading countries"),
            );
          }
          return SizedBox.shrink();
        }
    );
  }
}
