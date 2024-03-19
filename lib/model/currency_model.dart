import 'dart:convert';

LatestCurrency latestCurrencyFromJson(String str) =>
    LatestCurrency.fromJson(json.decode(str));

String latestCurrencyToJson(LatestCurrency data) => json.encode(data.toJson());

class LatestCurrency {
  String disclaimer;
  String license;
  int timestamp;
  String base;
  Map<String, double> rates;

  LatestCurrency({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  factory LatestCurrency.fromJson(Map<String, dynamic> json) => LatestCurrency(
        disclaimer: json["disclaimer"],
        license: json["license"],
        timestamp: json["timestamp"],
        base: json["base"],
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "disclaimer": disclaimer,
        "license": license,
        "timestamp": timestamp,
        "base": base,
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

// Currency types

Map<String, String> currencyTypesFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<String, String>(k, v));

String currencyTypesToJson(Map<String, String> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));
