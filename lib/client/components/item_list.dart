import 'package:construmatapp/admin/models/product_type.dart';
import 'package:construmatapp/client/components/cartao.dart';
import 'package:construmatapp/models/item.dart';
import 'package:construmatapp/models/lista_materiais.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key, required this.categoria}) : super(key: key);
  final ProductType categoria;
  final List<Item> cardapio = todosOsItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 32.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 150),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if(cardapio[index].type == categoria) {
              return Cartao(item: cardapio[index]);
            } else {
              return Container();
            }
          },
          scrollDirection: Axis.horizontal,
          itemCount: cardapio.length,
        ),
      ),
    );
  }
}