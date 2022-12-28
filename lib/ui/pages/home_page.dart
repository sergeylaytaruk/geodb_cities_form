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
import 'package:geodb_cities/ui/widgets/info.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final countriesRepository = CountriesRepository();
  final regionsRepository = RegionsRepository();
  final citiesRepository = CitiesRepository();

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
          BlocProvider(create: (context) => CountriesCubit(countriesRepository)..fetchCountries(lang: addressData.lang, searchValue: '')),
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
              SizedBox(height: 5,),
              Info(),
              //ActionButtons(),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: CountriesList(),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: RegionsList()
                ),
              ),
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
}
