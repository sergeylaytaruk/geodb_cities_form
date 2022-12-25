//import 'countries_cubit.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/countries_cubit.dart';
import 'package:geodb_cities/cubit/countries_state.dart';
import 'package:geodb_cities/cubit/regions_cubit.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';
import 'package:geodb_cities/data/models/countries.dart';

//import 'package:geodb_cities/data/providers/address_data.dart';

//final addressDataProvider = StateNotifierProvider<AddressDataNotifier, AddressData>((ref) => AddressDataNotifier(AddressData()));

class CountriesList extends ConsumerWidget {
  const CountriesList({Key? key}) : super(key: key);

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
            // return ListView.builder(
            //   itemCount: state.loadedCountires.length,
            //   itemBuilder: (context, index) => Container(
            //     color: index % 2 == 0 ? Colors.white : Colors.blue[50],
            //     child: ListTile(
            //       //leading: Text("${state.loadedCountires[index].code}"),
            //       title: Column(
            //         children: <Widget>[
            //           Text("${state.loadedCountires[index].name}"),
            //           Text("${state.loadedCountires[index].code}"),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
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
              children: [
                FormBuilderDropdown(
                  name: 'id_country',
                  decoration: InputDecoration(
                    labelText: 'Країна:',
                  ),
                  initialValue: null,
                  allowClear: false,
                  hint: Text("Оберіть країну"),
                  items: listItems,
                  onChanged: (String? value) {
                    if (value != null && value != '') {
                      Timer(const Duration(milliseconds: 1000), () {
                        final RegionsCubit regionsCubit = context.read<RegionsCubit>();
                        regionsCubit.clearRegions();
                        ref.read(addressDataProvider.notifier).updateContryCode(value);
                        regionsCubit.fetchRegions(lang: 'ru', searchValue: '', countryCode: value);
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
