import 'package:currency_converter_app/blocs/app_blocs.dart';
import 'package:currency_converter_app/blocs/app_events.dart';
import 'package:currency_converter_app/blocs/app_states.dart';
import 'package:currency_converter_app/model/currency_model.dart';
import 'package:currency_converter_app/repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController usCurrency = TextEditingController();
  TextEditingController anyCurrency = TextEditingController();
  String? dropdownValueForUs;
  String? dropdownFirstType;
  String? dropdownSecondType;
  String answer1 = 'Converted Currency will be shown here :)';
  String answer2 = 'Converted Currency will be shown here :)';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CurrencyBloc(RepositoryProvider.of<CurrencyRepository>(context))
            ..add(LoadCurrencyEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Currency Converter",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if (state is CurrencyLoadingState) {
              return Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }

            if (state is CurrencyLoadedState) {
              LatestCurrency currency = state.currency;
              List<String> code = state.countryCode;
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "USD to any currency type",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 25,
                                      fontFamily: "sans-serif-condensed-light",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: usCurrency,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter Amount In Dollers",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: dropdownValueForUs,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_rounded),
                                      iconSize: 24,
                                      elevation: 16,
                                      isExpanded: true,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.grey.shade400,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValueForUs = newValue!;
                                        });
                                      },
                                      items: code.map<DropdownMenuItem<String>>(
                                          (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text("Choose currency type"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.green)),
                                      onPressed: () {
                                        setState(() {
                                          var rates =
                                              dropdownValueForUs?.substring(
                                                  dropdownValueForUs!
                                                          .indexOf("(") +
                                                      1,
                                                  dropdownValueForUs
                                                      ?.indexOf(")"));
                                          var convertedValue = (currency
                                                      .rates["$rates"]! *
                                                  double.parse(usCurrency.text))
                                              .toStringAsFixed(2);
                                          answer1 = usCurrency.text.toString() +
                                              " USD = " +
                                              convertedValue +
                                              " $rates";
                                        });
                                      },
                                      child: Text(
                                        "Convert",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(answer1))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Convert to Any Currency",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 25,
                                      fontFamily: "sans-serif-condensed-light",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: anyCurrency,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter Amount to Convert",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownButton<String>(
                                value: dropdownFirstType,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Colors.grey.shade400,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownFirstType = newValue!;
                                  });
                                },
                                items:
                                    code.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                hint: Text("Choose currency type"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "To",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              DropdownButton<String>(
                                value: dropdownSecondType,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Colors.grey.shade400,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownSecondType = newValue!;
                                  });
                                },
                                items:
                                    code.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                hint: Text("Choose currency type"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: () {
                                    setState(() {
                                      var currencyRatesFrom =
                                          dropdownFirstType?.substring(
                                              dropdownFirstType!.indexOf("(") +
                                                  1,
                                              dropdownFirstType!.indexOf(")"));
                                      var currencyRatesTo =
                                          dropdownSecondType?.substring(
                                              dropdownSecondType!.indexOf("(") +
                                                  1,
                                              dropdownSecondType!.indexOf(")"));
                                      var convertedValue = (double.parse(
                                                  anyCurrency.text) /
                                              currency.rates[
                                                  "$currencyRatesFrom"]! *
                                              currency
                                                  .rates["$currencyRatesTo"]!)
                                          .toStringAsFixed(4);
                                      answer2 = anyCurrency.text.toString() +
                                          " $currencyRatesFrom = " +
                                          convertedValue +
                                          " $currencyRatesTo";
                                    });
                                  },
                                  child: Text(
                                    "Convert",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(answer2))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
