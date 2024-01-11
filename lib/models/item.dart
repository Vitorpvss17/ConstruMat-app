import 'package:construmatapp/admin/models/product_type.dart';
import 'package:uuid/uuid.dart';

class Item {
  late final String id;
  final String nome;
  final ProductType type;
  final String imagePath;
  final int quantidade;
  final String createdBy;

  Item({
    String? id,
    required this.nome,
    required this.type,
    required this.imagePath,
    required this.quantidade,
    required this.createdBy,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'type': type.toMap(),
      'imagePath': imagePath,
      'quantidade': quantidade,
      'createdBy': createdBy,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      nome: map['nome'],
      type: ProductType.fromMap(map['type']),
      imagePath: map['imagePath'],
      quantidade: map['quantidade'],
      createdBy: map['createdBy'],
    );
  }
}