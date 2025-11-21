import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_explorer/core/network/connectivity_cubit.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late ConnectivityCubit cubit;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    when(() => mockConnectionChecker.onStatusChange)
        .thenAnswer((_) => Stream.value(InternetConnectionStatus.connected));
    when(() => mockConnectionChecker.hasConnection)
        .thenAnswer((_) async => true);
  });

  test('initial state is true (connected)', () async {
    cubit = ConnectivityCubit(connectionChecker: mockConnectionChecker);
    await Future.delayed(Duration.zero);
    expect(cubit.state, true);
  });

  blocTest<ConnectivityCubit, bool>(
    'emits [false] when connection is lost',
    build: () {
      when(() => mockConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      when(() => mockConnectionChecker.onStatusChange).thenAnswer(
          (_) => Stream.fromIterable([InternetConnectionStatus.disconnected]));
      return ConnectivityCubit(connectionChecker: mockConnectionChecker);
    },
    expect: () => [false],
  );

  group('connection restored', () {
    late StreamController<InternetConnectionStatus> controller;

    blocTest<ConnectivityCubit, bool>(
      'emits [false, true] when connection is restored',
      setUp: () {
        when(() => mockConnectionChecker.hasConnection)
            .thenAnswer((_) async => false);
        controller = StreamController<InternetConnectionStatus>();
        when(() => mockConnectionChecker.onStatusChange)
            .thenAnswer((_) => controller.stream);
      },
      build: () => ConnectivityCubit(connectionChecker: mockConnectionChecker),
      act: (cubit) async {
        await Future.delayed(Duration(milliseconds: 10));
        controller.add(InternetConnectionStatus.connected);
      },
      tearDown: () => controller.close(),
      expect: () => [false, true],
    );
  });
}
