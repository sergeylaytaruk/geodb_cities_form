import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:geodb_cities/cubit/cities_state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';
import 'package:geodb_cities/data/models/cities.dart';

class CitiesList extends ConsumerWidget {
  const CitiesList({Key? key}) : super(key: key);

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
            //String? codeCountry = null;
            return FormBuilderDropdown(
              name: 'id_city',
              //validator: appValidators.settingCountryValidator,
              decoration: InputDecoration(
                labelText: 'Місто:',
              ),
              initialValue: null,
              allowClear: false,
              hint: Text("Оберіть місто"),
              items: listItems,
              onChanged: (String? value) {
                if (value != null && value != '') {
                  ref.read(addressDataProvider.notifier).updateCityId(value);
                }
              },
              menuMaxHeight: 300,
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
