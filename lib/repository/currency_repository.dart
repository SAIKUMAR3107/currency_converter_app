import 'package:http/http.dart' as http;

import '../model/currency_model.dart';

class CurrencyRepository {
  var apiId = "04f299005c12454c91a94b7e050de635";
  List<String> countryCode = [];
  String? dropdownValueForUs;
  String? dropdownFirstType;
  String? dropdownSecondType;

  Future<LatestCurrency> getCurrency(http.Client http) async {
    try {
      var response = await http.get(Uri.parse(
          "https://openexchangerates.org/api/latest.json?app_id=" + apiId));
      if (response.statusCode == 200) {
        LatestCurrency result = latestCurrencyFromJson(response.body);
        return result;
      } else {
        // Handle server error
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      // Handle network error or any other exceptions
      throw Exception("Failed to load data : $e");
    }
  }

  Future<List<String>> getCurrencyTypes() async {
    try {
      var response = await http.Client()
          .get(Uri.parse("https://openexchangerates.org/api/currencies.json"));
      if (response.statusCode == 200) {
        var result = currencyTypesFromJson(response.body);
        result.forEach((key, value) {
          countryCode.add("$value ($key)");
        });
        dropdownValueForUs = countryCode[0];
        dropdownFirstType = countryCode[1];
        dropdownSecondType = countryCode[2];
        return countryCode;
      }
      else {
        // this block is for handling the server error
        throw Exception('Failed to load currency types: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error or any other exceptions
      throw Exception('Failed to load currency types: $e');
    }

  }
}
