

import 'package:construmatapp/receiver/components/manage_items_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Itens'),
      ),
      body: currentUser != null ? ManageItemsList(user: currentUser) : Container(),
    );
  }
}