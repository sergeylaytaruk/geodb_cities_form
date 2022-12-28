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
  final _formSelectFieldKey = GlobalKey<FormBuilderFieldState>();

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
                        return TextFormField(
                          autofocus: true,
                          initialValue: '',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: "Пошук країни",
                            isDense: false,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          ),
                          onChanged: (value) {
                            timerSearchContries?.cancel();
                            timerSearchContries = Timer(const Duration(milliseconds: 1000), () {
                              final CountriesCubit countriesCubit = context.read<CountriesCubit>();
                              final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              countriesCubit.clearCountries();
                              regionsCubit.clearRegions();
                              citiesCubit.clearCities();
                              countriesCubit.fetchCountries(lang: addressData.lang, searchValue: value);
                            });
                          },
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                        );
                      }
                  ),
                ),
                FormBuilderDropdown<String>(
                  key: _formSelectFieldKey,
                  name: 'id_country',
                  decoration: InputDecoration(
                    labelText: 'Країна:',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formSelectFieldKey.currentState?.reset();
                        final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        regionsCubit.clearRegions();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateContryCode(null);
                        ref.read(addressDataProvider.notifier).updateRegionId(null);
                        ref.read(addressDataProvider.notifier).updateCityId(null);
                      },
                    ),
                    hintText: 'Оберіть країну:',
                  ),
                  initialValue: addressData.contryCode,
                  allowClear: false,
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      Timer(const Duration(milliseconds: 1000), () {
                        final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        regionsCubit.clearRegions();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateContryCode(value);
                        ref.read(addressDataProvider.notifier).updateRegionId(null);
                        ref.read(addressDataProvider.notifier).updateCityId(null);
                        regionsCubit.fetchRegions(lang: addressData.lang, searchValue: '', countryCode: value);
                        //final CountriesCubit countriesCubit = context.read<CountriesCubit>();
                        //countriesCubit.selectedCountries();
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
