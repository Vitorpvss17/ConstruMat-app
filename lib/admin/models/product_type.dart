enum ItemType {
  maisPedidos,
  massas,
  ceramicas,
}

class ProductType {
  String name;
  ProductType({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static ProductType fromMap(Map<String, dynamic> map) {
    return ProductType(
      name: map['name'],
    );
  }
}