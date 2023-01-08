import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_fridge/authentication_page.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/household/household_add_form.dart';
import 'package:my_fridge/household/join_household.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/model/services/authentication_service.dart';
import 'package:my_fridge/model/services/household_service.dart';
import 'package:my_fridge/model/services/user_service.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyCOHzywyUXiibHAAZa-yoZODkyMg-zss00",
              appId: "1:265628210515:web:0e79960c7ab5ae375afda6",
              messagingSenderId: "265628210515",
              projectId: "myfridge-e530e",
              authDomain: "myfridge-e530e.firebaseapp.com")),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return InitializeProviders();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loader();
      },
    );
  }
}

class InitializeProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        Provider<UserService>(create: (_) => UserService()),
        Provider<HouseholdService>(create: (_) => HouseholdService()),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'My Fridge',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('fr', ''),
        ],
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
            )),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final fireBaseUser = context.watch<User?>();
    if (fireBaseUser == null) {
      return const AuthenticationPage();
    }

    return FutureBuilder<MyFridgeUser>(
        future: UserService.getCurrentUserFromDb(context),
        builder: (context, AsyncSnapshot<MyFridgeUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            MyFridgeUser? user = snapshot.data;
            if (user == null) {
              user = MyFridgeUser(
                  id: fireBaseUser.uid,
                  username: fireBaseUser.displayName!,
                  email: fireBaseUser.email!,
                  imageUrl: fireBaseUser.photoURL!,
                  householdsId: []);
              UserService.create(user, context);
            }
            // Save the current connected user
            context.read<UserService>().currentUser = user;
            if (user.selectedHouseholdId == null) {
              return buildWelcomePage(context);
            }
            return buildApp(context);
          }
          return const Loader();
        });
  }

  Widget buildApp(BuildContext context) {
    return FutureBuilder<Household>(
        future: HouseholdService.getSelectedHouseholdFromDb(context),
        builder: (context, AsyncSnapshot<Household> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            context.read<HouseholdService>().currentHousehold = snapshot.data;
            return const CustomBottomNavigationBar();
          }
          return const Loader();
        });
  }

  Widget buildWelcomePage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddHousehold())),
          child: Text(AppLocalizations.of(context)!.household_create),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JoinHousehold())),
        child: Text(AppLocalizations.of(context)!.household_join),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        ),
      ),
    ]);
  }
}
