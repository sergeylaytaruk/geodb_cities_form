import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/countries_cubit.dart';
import 'package:geodb_cities/cubit/countries_state.dart';
import 'package:geodb_cities/cubit/internet_cubit.dart';
import 'package:geodb_cities/cubit/regions_cubit.dart';
import 'package:geodb_cities/cubit/regions_state.dart';
import 'package:geodb_cities/cubit/cities_cubit.dart';
import 'package:geodb_cities/cubit/cities_state.dart';
//import 'package:geodb_cities/bloc/countries_bloc.dart';
//import 'package:geodb_cities/data/repositories/countries_repo.dart';
import 'package:geodb_cities/data/repositories/countries_repository.dart';
import 'package:geodb_cities/data/repositories/regions_repository.dart';
import 'package:geodb_cities/data/repositories/cities_repository.dart';
//import 'package:geodb_cities/ui/pages/search_page.dart';
import 'package:geodb_cities/ui/widgets/action_buttons.dart';
import 'package:geodb_cities/ui/widgets/countries_list.dart';
import 'package:geodb_cities/ui/widgets/regions_list.dart';
import 'package:geodb_cities/ui/widgets/cities_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final countriesRepository = CountriesRepository();
  final regionsRepository = RegionsRepository();
  final citiesRepository = CitiesRepository();
  Timer? timerSearchContries;
  Timer? timerSearchRegions;
  Timer? timerSearchCities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressData = ref.watch(addressDataProvider);
    final double paddingH = 10.0;
    final double paddingV = 5.0;
    return RepositoryProvider(
      create: (context) => CountriesRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ConnectionCubit()),
          BlocProvider(create: (context) => CountriesCubit(countriesRepository)..fetchCountries(lang: 'ru', searchValue: '')),
          BlocProvider(create: (context) => RegionsCubit(regionsRepository)),
          BlocProvider(create: (context) => CitiesCubit(citiesRepository)),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ConnectionCubit, MyConnectionState>(
              builder: (context, state) => state.connected
                  ? const Text('online')
                  : const Text('offline!', style: TextStyle(color: Colors.red),),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                child: Text("Країна: ${addressData.contryCode.toString()}", style: TextStyle(color: Colors.black, fontSize: 22),),
              ),
              //ActionButtons(),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
                            countriesCubit.fetchCountries(lang: 'ru', searchValue: value);
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
              ),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: CountriesList(),
                ),
              ),
              addressData.contryCode != null ?
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
                              regionsCubit.fetchRegions(lang: 'ru', searchValue: value, countryCode: addressData.contryCode.toString());
                              final CitiesCubit citiesCubit = context.read<CitiesCubit>();
                              citiesCubit.clearCities();
                            });
                          },
                        );
                      }
                  ),
                ),
              ) : Expanded(child: Container(), flex: 0,),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: RegionsList()
                ),
              ),
              addressData.contryCode != null && addressData.regionId != null  ?
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
                              citiesCubit.fetchCities(lang: 'ru', searchValue: value, countryCode: addressData.contryCode.toString(), regionCode: addressData.regionId.toString());
                            });
                          },
                        );
                      }
                  ),
                ),
              ) : Expanded(child: Container(), flex: 0,),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: CitiesList()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color:Colors.indigoAccent,
        width: 1,
      ),
    );
  }
}
