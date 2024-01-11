import 'package:construmatapp/admin/models/types.dart';
import 'package:construmatapp/construmatapp.dart';
import 'package:construmatapp/firebase_options.dart';
import 'package:construmatapp/receiver/models/items.dart';
import 'package:construmatapp/receiver/screens/gerenciar_items_screen.dart';
import 'package:construmatapp/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'client/stores/cart_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        Provider<CartStore>(
          create: (_) => CartStore(),
        ),
        ChangeNotifierProvider<Items>(
          create: (context) => Items(items: []),
          child: const ManageItemsScreen(),
        ),
        ChangeNotifierProvider<Types>(create: (context) {
          Types typesProvider = Types(types: []);
          typesProvider.initializeDefaultTypes();
          return typesProvider;
        }),
      ],
      child: const ConstruMatApp(),
    ),
  );
}
