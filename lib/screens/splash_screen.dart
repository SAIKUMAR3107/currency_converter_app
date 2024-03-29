import 'dart:async';

import 'package:currency_converter_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/currency_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryProvider(
              create: (context) => CurrencyRepository(),
              child: HomeScreen(),
            ),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/currency_icon.png",
                  height: 60,
                  width: 60,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              "Currency Converter",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
