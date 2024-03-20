
import 'dart:convert';

import 'package:currency_converter_app/model/currency_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:currency_converter_app/repository/currency_repository.dart';

void main(){
  group("getCurrency", () { 
    test("returns currency details string when http response is successful", () async{
      final mockHttpClient = MockClient((request) async{
        final response = {
        "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
        "license": "https://openexchangerates.org/license",
        "timestamp": 1710914400,
        "base": "USD",
        "rates": {}
        };
        return Response(jsonEncode(response), 200);
      });
      expect(await CurrencyRepository().getCurrency(mockHttpClient), isA<LatestCurrency>());
    });

  });
  
  
}