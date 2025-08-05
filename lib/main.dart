import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/domain/auth_repo.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/splash/splash.dart';
import 'core/store/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoreData.instant.initCache();
  await AuthRepository.instance.initializeAuthState();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
