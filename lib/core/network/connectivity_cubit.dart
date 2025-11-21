import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityCubit extends Cubit<bool> {
  final InternetConnectionChecker connectionChecker;
  StreamSubscription? _subscription;

  ConnectivityCubit({required this.connectionChecker}) : super(true) {
    _subscription = connectionChecker.onStatusChange.listen((status) {
      emit(status == InternetConnectionStatus.connected);
    });
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    final isConnected = await connectionChecker.hasConnection;
    emit(isConnected);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
