import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geodb_cities/data/providers/providers.dart';

class Info extends ConsumerStatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  ConsumerState<Info> createState() => _InfoState();
}

class _InfoState extends ConsumerState<Info> {

  final double paddingH = 10.0;
  final double paddingV = 5.0;
  String country = '';
  String region = '';
  String city = '';

  @override
  Widget build(BuildContext context) {
    ref.listen(addressDataProvider, (previousState, currentState) {
      country = currentState.contryCode ?? '';
      region = currentState.regionId ?? '';
      city = currentState.cityId ?? '';
      setState() {};
    });
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: Text("Країна: ${country} Область: ${region} Місто: ${city} ", style: TextStyle(color: Colors.black, fontSize: 22),),
    );
  }
}
