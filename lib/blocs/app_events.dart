import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CurrencyEvents extends Equatable {
  const CurrencyEvents();
}

class LoadCurrencyEvent extends CurrencyEvents {
  @override
  List<Object?> get props => [];
}
