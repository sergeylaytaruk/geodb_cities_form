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
  final _formSelectFieldKey = GlobalKey<FormBuilderFieldState>();

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
                        return TextFormField(
                          autofocus: true,
                          initialValue: '',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: "Пошук міста",
                            isDense: false,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          ),
                          onChanged: (value) {
                            timerSearchCities?.cancel();
                            timerSearchCities = Timer(const Duration(milliseconds: 1000), () {
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              citiesCubit.clearCities();
                              citiesCubit.fetchCities(lang: addressData.lang, searchValue: value, countryCode: addressData.contryCode.toString(), regionCode: addressData.regionId.toString());
                            });
                          },
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                        );
                      }
                  ),
                ) : Expanded(child: Container(), flex: 0,),
                FormBuilderDropdown<String>(
                  key: _formSelectFieldKey,
                  name: 'id_city',
                  decoration: InputDecoration(
                    labelText: 'Місто:',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formSelectFieldKey.currentState?.reset();
                        final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                        citiesCubit.clearCities();
                        ref.read(addressDataProvider.notifier).updateCityId(null);
                      },
                    ),
                    hintText: 'Оберіть місто:',
                  ),
                  initialValue: addressData.cityId,
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
          return SizedBox.shrink();
        }
    );
  }
}
