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

  @override
  Widget build(BuildContext context) {
    final addressData = ref.watch(addressDataProvider);
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: Text("Країна: ${addressData.contryCode.toString()} Область: ${addressData.regionId.toString()} Місто: ${addressData.cityId.toString()} ", style: TextStyle(color: Colors.black, fontSize: 22),),
    );
  }
}
