import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List exchangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (BuildContext context, int index) {
            String _currency = _currencies[index].toString().toUpperCase();
            String _exchangeRates = exchangeRates[index].toString();
            return ListTile(
              title: Text("$_currency : $_exchangeRates ", style: TextStyle(color: Colors.white),),
            );
          },
        ),
      ),
    );
  }
}
