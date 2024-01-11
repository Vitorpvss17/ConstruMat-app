


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/client/components/order_item.dart';
import 'package:construmatapp/client/stores/cart_store.dart';
import 'package:construmatapp/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  Checkout({Key? key, required this.homeContext, required this.onOrderPlaced, required this.user}) : super(key: key);
  final BuildContext homeContext;
  final VoidCallback onOrderPlaced;
  User? user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;
    final cartStore = Provider.of<CartStore>(homeContext, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: <Widget>[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Pedido",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return OrderItem(item: cartStore.itemList[index]);
                }, childCount: cartStore.itemList.length),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Pagamento",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Confirmar",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? nomeSolicitante = await getNomeSolicitante(user);
                      sendOrderToFirebase(cartStore.itemList, cartStore, nomeSolicitante);
                      onOrderPlaced();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.account_balance_wallet),
                        ),
                        Text(
                          "Pedir",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getNomeSolicitante(User? user) async {
    if (user != null) {
      return await fetchNomeFromFirestore(user.uid);
    }
    return null;
  }

  Future<String?> fetchNomeFromFirestore(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot userDocument = await firestore.collection('users').doc(userId).get();

      if (userDocument.exists) {
        return userDocument['nome'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void sendOrderToFirebase(List<Item> itemList, CartStore cartStore, String? nomeSolicitante) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference documentReference = await firestore.collection('pedidos').add({
        'data_pedido': DateTime.now(),
        'nomeSolicitante': nomeSolicitante ?? 'Nome do Solicitante',
        'itens': itemList.map((item) {
          return {
            'nome': item.nome,
            'quantidade': item.quantidade,
            'imagePath': item.imagePath,
            'type': {
              'name': item.type.name,
            },
          };
        }).toList(),
      });
      String pedidoId = documentReference.id;
      onOrderPlaced();
    } catch (e) {
      throw Exception('Erro ao enviar pedido para o Firebase: $e');
    }
  }
}
