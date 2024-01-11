import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/models/item.dart';
import 'package:construmatapp/receiver/models/items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../admin/models/product_type.dart';

class ManageItemsList extends StatelessWidget {
  final User user;

  const ManageItemsList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: fetchUserItems(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Item> userItems = snapshot.data ?? [];
            return ListView.builder(
                itemCount: userItems.length,
                itemBuilder: (context, index) {
                  Item item = userItems[index];
                  return Dismissible(
                    key: ValueKey<Item>(item),
                    onDismissed: (direction) {
                      removeItem(context, item);
                    },
                    child: ListTile(
                      title: Text(item.nome),
                      subtitle: Text('Quantidade: ${item.quantidade}'),
                    ),
                  );
                });
          }
        });
  }

  void removeItem(BuildContext context, Item item) async {
    try {
      String itemId = item.id;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> itemRef = firestore.collection('items').doc(itemId);



      print('ID do Item a ser removido: $itemId');

      await itemRef.delete();



      Provider.of<Items>(context, listen: false).remove(item);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removido com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover item: $e'),
        ),
      );
    }
  }

  Future<List<Item>> fetchUserItems(String userId) async {
    try {
      FirebaseFirestore firestone = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestone
          .collection('items')
          .where('createdBy', isEqualTo: userId)
          .get();

      List<Item> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String categoryName = data['type']['name'];
        return Item(
          nome: data['nome'],
          quantidade: data['quantidade'],
          imagePath: data['imagePath'],
          type: ProductType(name: categoryName),
          createdBy: userId,
        );
      }).toList();

      return items;
    } catch (e) {
      throw Exception('Error fetching user items: $e');
    }
  }
}
