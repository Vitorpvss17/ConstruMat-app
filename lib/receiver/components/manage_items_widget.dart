import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../admin/models/product_type.dart';

class ManageItemsList extends StatefulWidget {
  final User user;

  const ManageItemsList({super.key, required this.user});

  @override
  State<ManageItemsList> createState() => _ManageItemsListState();
}

class _ManageItemsListState extends State<ManageItemsList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: fetchUserItems(widget.user.uid),
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
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8.0),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
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
      firestore.collection('items').doc(item.id).delete();

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
      QuerySnapshot querySnapshot = await firestore
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
