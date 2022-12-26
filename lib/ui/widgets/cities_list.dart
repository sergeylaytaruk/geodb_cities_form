import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:geodb_cities/cubit/cities_state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';
import 'package:geodb_cities/data/models/cities.dart';
import 'package:geodb_cities/ui/widgets/input_border.dart';

class CitiesList extends ConsumerWidget {
  CitiesList({Key? key}) : super(key: key);

  Timer? timerSearchCities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressData = ref.watch(addressDataProvider);
    return BlocBuilder<CitiesCubit, CitiesState>(
        builder: (context, state) {
          if (state is CitiesEmptyState) {
            return Center(
              child: Text("No data received."),
            );
          }
          if (state is CitiesLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CitiesLoadedState) {
            List<DropdownMenuItem<String>> listItems = [];
            state.loadedCities.forEach((item) {
              listItems.add(
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Text(
                        item.name,
                      ),
                    ],
                  ),
                  value: item.id.toString(),
                ),
              );
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                addressData.contryCode != null && addressData.regionId != null  ?
                Expanded(
                  flex: 0,
                  child: BlocBuilder<CitiesCubit, CitiesState>(
                      builder: (context, state) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: "Пошук міста",
                            enabledBorder: myInputBorder(),
                            focusedBorder: myInputBorder(),
                          ),
                          onChanged: (value) {
                            timerSearchCities?.cancel();
                            timerSearchCities = Timer(const Duration(milliseconds: 1000), () {
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              citiesCubit.clearCities();
                              citiesCubit.fetchCities(lang: addressData.lang, searchValue: value, countryCode: addressData.contryCode.toString(), regionCode: addressData.regionId.toString());
                            });
                          },
                        );
                      }
                  ),
                ) : Expanded(child: Container(), flex: 0,),
                FormBuilderDropdown(
                  name: 'id_city',
                  decoration: InputDecoration(
                    labelText: 'Оберіть місто:',
                  ),
                  initialValue: null,
                  allowClear: false,
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      ref.read(addressDataProvider.notifier).updateCityId(value);
                    }
                  },
                  menuMaxHeight: 300,
                ),
              ],
            );
          }
          if (state is CitiesErrorState) {
            return Center(
              child: Text("Error loading cities"),
            );
          }
          //return SizedBox(height: 3,);
          return SizedBox.shrink();
        }
    );
  }
}
