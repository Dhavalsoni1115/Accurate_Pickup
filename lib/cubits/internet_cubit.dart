import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetCubitState { Initial, Gained, Lost }

class InternetCubit extends Cubit<InternetCubitState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  InternetCubit() : super(InternetCubitState.Initial) {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((request) {
      if ([ConnectivityResult.mobile, ConnectivityResult.wifi].contains(request)) {
        return emit(InternetCubitState.Lost);
      } else {
        return emit(InternetCubitState.Lost);
      }
    });
  }
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
