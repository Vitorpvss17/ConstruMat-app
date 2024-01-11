import 'package:construmatapp/models/item.dart';

enum StatusPedido{
  aprovado,
  recusado,
}

class Pedido {
  final String id;
  final String nomeSolicitante;
  final List<Item> itens;
  StatusPedido status;


  Pedido({required this.id, required this.nomeSolicitante, required this.itens, required this.status});
}