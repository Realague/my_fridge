import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fridge/authentication_page.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/services/user.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges, initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'My Fridge',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fireBaseUser = context.watch<User?>();

    if (fireBaseUser != null) {
      UserService.create(
          fireBaseUser.uid, fireBaseUser.displayName!, fireBaseUser.email!);
      return CustomBottomNavigationBar();
    } else {
      return AuthenticationPage();
    }
  }
}
