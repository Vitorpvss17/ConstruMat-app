import 'package:construmatapp/admin/models/product_type.dart';
import 'package:flutter/material.dart';

class Types extends ChangeNotifier{
  List<ProductType> types;

  Types({
    required this.types
  });

  void initializeDefaultTypes() {
    types = [
      ProductType(name: "Mais pedidos"),
      ProductType(name: "Massas"),
      ProductType(name: "Cerâmicas"),

    ];

    notifyListeners();
  }


  void add(ProductType type){
    types.add(type);
    notifyListeners();
  }

  void remove(int index){
    types.remove(index);
    notifyListeners();
  }
}