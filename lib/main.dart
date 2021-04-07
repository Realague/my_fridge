import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fridge/authentication_page.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/services/user.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  /*await Firebase.initializeApp(
  name: "my_fridge",
  options: const FirebaseOptions(
  apiKey: "AIzaSyCOHzywyUXiibHAAZa-yoZODkyMg-zss00",
  appId: "1:265628210515:web:0e79960c7ab5ae375afda6",
  messagingSenderId: "265628210515",
  projectId: "myfridge-e530e",
  authDomain: "myfridge-e530e.firebaseapp.com",
  measurementId: "G-5BTWZSMGE9",
  storageBucket: "myfridge-e530e.appspot.com",
  ));ù*/
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<AuthenticationService>(
                create: (_) => AuthenticationService(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) => context.read<AuthenticationService>().authStateChanges,
                initialData: null,
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
          );;
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text("loading...");
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fireBaseUser = context.watch<User?>();

    if (fireBaseUser != null) {
      UserService.create(fireBaseUser.uid, fireBaseUser.displayName!, fireBaseUser.email!);
      return CustomBottomNavigationBar();
    } else {
      return AuthenticationPage();
    }
  }
}
