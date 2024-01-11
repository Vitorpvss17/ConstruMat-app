import 'package:construmatapp/client/components/contador.dart';
import 'package:construmatapp/models/item.dart';
import 'package:flutter/material.dart';

class Cartao extends StatelessWidget {
  const Cartao({ Key? key, required this.item }) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context){
    return Card(
      color: const Color(0xFFF6F6F6),
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 134),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image(
              image: AssetImage(item.imagePath),
              width: double.infinity,
              height: 50,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Contador(item: item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
