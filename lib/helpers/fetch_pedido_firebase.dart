import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/admin/models/product_type.dart';
import 'package:construmatapp/models/item.dart';
import 'package:construmatapp/models/pedido.dart';
import 'package:flutter/material.dart';
import '../admin/models/types.dart';

class OrderHelper {
  late Timer timer;
  late List<Pedido> pedidos;
  final Types typesProvider;
  final BuildContext context;
  final String userId;

  OrderHelper(this.typesProvider, this.context, this.userId) {
    pedidos = [];
    initializeTimer();
  }

  Future<List<Pedido>> fetchPedidosFromFirebase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    ProductType dropdownValue = typesProvider.types[0];

    try {
      QuerySnapshot querySnapshot = await firestore.collection('pedidos').get();

      List<Pedido> pedidos = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        StatusPedido status = data['status'] != null
            ? StatusPedido.values.firstWhere(
              (e) => e.toString() == 'StatusPedido.${data['status']}',
          orElse: () => StatusPedido.aprovado,
        )
            : StatusPedido.aprovado;

        return Pedido(
          nomeSolicitante: data['nomeSolicitante'],
          itens: (data['itens'] as List<dynamic>).map((itemData) {
            return Item(
              nome: itemData['nome'],
              quantidade: itemData['quantidade'],
              type: dropdownValue,
              imagePath: '',
              createdBy: userId,
            );
          }).toList(),
          status: status,
          id: doc.id,
        );
      }).toList();

      return pedidos;
    } catch (e) {
      throw Exception('Error fetching pedidos: $e');
    }
  }

  void initializeTimer() {
    timer = Timer.periodic(const Duration(hours: 24), (timer) {
      pedidos.clear();
    });
  }

  Future<void> updatePedidoStatus(String pedidoId, StatusPedido novoStatus) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot pedidoDoc =
      await firestore.collection('pedidos').doc(pedidoId).get();

      if (pedidoDoc.exists) {
        await firestore.collection('pedidos').doc(pedidoId).update({
          'status': novoStatus.toString().split('.')[1],
        });
      } else {
        showErrorMessage('Pedido não encontrado.');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar o status do pedido: $e');
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}