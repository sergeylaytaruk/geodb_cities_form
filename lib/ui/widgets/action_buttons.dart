import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geodb_cities/cubit/countries_cubit.dart';
import 'package:geodb_cities/cubit/countries_state.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CountriesCubit countriesCubit = context.read<CountriesCubit>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          child: Text("Load"),
          onPressed: () {
            countriesCubit.fetchCountries(lang: 'ru', searchValue: '');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
        ),
        SizedBox(width: 8,),
        ElevatedButton(
          child: Text("Clear"),
          onPressed: () {
            //countriesBloc.add(CountriesClearEvent);
            countriesCubit.clearCountries();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
        ),
      ],
    );
  }
}
