import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/network/connectivity_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/pokemon_list/presentation/pages/pokemon_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ConnectivityCubit>()),
      ],
      child: MaterialApp(
        title: 'Pokémon Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const PokemonListScreen(),
      ),
    );
  }
}
