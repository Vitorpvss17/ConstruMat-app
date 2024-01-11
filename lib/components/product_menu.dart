import 'dart:io';

import 'package:flutter/material.dart';

import '../receiver/screens/gerenciar_items_screen.dart';

class ProductMenu extends StatelessWidget {
  const ProductMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
                'Menu',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20
                )),
          ),
          ListTile(
            title: const Text('Gerenciar Pedidos'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Gerenciar Items'),
            onTap: () {
              Navigator.of(context).pop(); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageItemsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}
