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
  String answer1 = 'Converted Currency will be :';
  String answer2 = 'Converted Currency will be :';
  bool isContainsData1 = true;
  bool isContainsData2 = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CurrencyBloc(RepositoryProvider.of<CurrencyRepository>(context))
            ..add(LoadCurrencyEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF352315),
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.fill)),
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
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.fill)),
                padding: EdgeInsets.only(left: 10,right: 10,top: 10),
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
                              Container(alignment:Alignment.topLeft,child: Text(isContainsData2 ? " " : "Enter valid Amount",style: TextStyle(color: Colors.red),)),
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
                              SizedBox(width: 150,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(
                                            Colors.green)),
                                    onPressed: () {
                                      setState(() {
                                        if(anyCurrency.text.isNotEmpty && dropdownFirstType!.isNotEmpty && dropdownSecondType!.isNotEmpty){
                                          isContainsData2 = true;
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
                                        }
                                        else{
                                          isContainsData2 = false;
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choose both the currency type values")));
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Convert",
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(answer2,style: TextStyle(fontSize: 20),))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              Container(alignment:Alignment.topLeft,child: Text(isContainsData1 ? " " : "Enter valid Amount",style: TextStyle(color: Colors.red),)),
                              DropdownButton<String>(
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
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(width: 150,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStatePropertyAll(
                                            Colors.green)),
                                    onPressed: () {
                                      setState(() {
                                        if(usCurrency.text.isNotEmpty && dropdownValueForUs!.isNotEmpty){
                                          isContainsData1 = true;
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
                                        }
                                        else{
                                          isContainsData1 = false;
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choose the Currency type")));
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Convert",
                                      style: TextStyle(color: Colors.white,fontSize: 18),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text(answer1,style: TextStyle(fontSize: 20),))
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