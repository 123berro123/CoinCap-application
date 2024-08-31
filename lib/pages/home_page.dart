import 'dart:convert';

import 'package:coincapp/pages/details_page.dart';
import 'package:coincapp/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceheight, _devicewidth;
  String? _selectedCoin = "bitcoin";
  HTTPSERVICE? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPSERVICE>();
  }

  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedCoindropdown(),
            _dataWidgets(),
          ],
        ),
      )),
    );
  }

  Widget _selectedCoindropdown() {
    List<String> _coins = ["bitcoin", "ethereum", "tether", "cardano", "riple"];

    List<DropdownMenuItem<String>> _items = _coins
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ))
        .toList();

    return DropdownButton<String>(
      value: _selectedCoin,
      items: _items,
      onChanged: (_value) {
        _selectedCoin = _value;
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
        future: _http!.get("/coins/$_selectedCoin"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            Map _data = jsonDecode(_snapshot.data.toString());
            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _change24 = _data["market_data"]["price_change_percentage_24h"];
            Map _exchangeRates = _data["market_data"]["current_price"];
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext _context) {
                        return DetailsPage(rates :_exchangeRates);
                      }));
                    },
                    child: _coinImage(_data["image"]["large"])),
                _currentPrice(_usdPrice),
                _percentageChange(_change24),
                _descriptionCard(_data["description"]["en"])
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }

  Widget _currentPrice(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
    );
  }

  Widget _percentageChange(num _change) {
    return Text(
      "${_change.toString()} %",
      style: TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget _coinImage(String _imgUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _deviceheight! * 0.02),
      child: Container(
          height: _deviceheight! * 0.15,
          width: _devicewidth! * 0.15,
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(_imgUrl)))),
    );
  }

  Widget _descriptionCard(String _description) {
    return Container(
      height: _deviceheight! * 0.45,
      width: _devicewidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceheight! * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: _deviceheight! * 0.01, horizontal: _deviceheight! * 0.01),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        _description,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
