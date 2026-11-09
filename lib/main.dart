import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/Views/appmainscreen.dart';
import 'package:recipe_app/providers/favourite_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavouriteProviders())],
      child: MaterialApp(
        title: 'Reciepe App',
        debugShowCheckedModeBanner: false,
        home: AppMainScreen(),
      ),
    );
  }
}
