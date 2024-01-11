import 'package:construmatapp/admin/models/product_type.dart';
import 'package:construmatapp/models/item.dart';
ProductType mapItemTypeToProductType(ItemType itemType) {
 switch (itemType) {
  case ItemType.maisPedidos:
   return ProductType(name: "Mais Pedidos");
  case ItemType.massas:
   return ProductType(name: "Massas");
  case ItemType.ceramicas:
   return ProductType(name: "Cerâmicas");
 }
}
const String _imageInitialPath = "assets/images";

 List<Item> todosOsItems = <Item>[
  Item(nome:"massa de reboco", type: mapItemTypeToProductType(ItemType.maisPedidos), imagePath:"$_imageInitialPath/massa_reboco.jpeg", quantidade: 50, createdBy: 'andar1'),
  Item(nome:"massa de emboço", type:mapItemTypeToProductType(ItemType.maisPedidos), imagePath:"$_imageInitialPath/massa_emboço.jpg", quantidade: 50, createdBy: 'andar1'),
  Item(nome:"massa de chapisco", type: mapItemTypeToProductType(ItemType.massas), imagePath:"$_imageInitialPath/massa_chapisco.jpeg", quantidade: 50, createdBy: 'andar1'),
  Item(nome:"rejunte cinza", type: mapItemTypeToProductType(ItemType.massas), imagePath:"$_imageInitialPath/rejunte_cinza.png", quantidade: 50, createdBy: 'andar1'),
  Item(nome:"cerâmica de cozinha-parede", type: mapItemTypeToProductType(ItemType.ceramicas), imagePath:"$_imageInitialPath/cerâmica_cozinha_parede.jpg", quantidade: 1, createdBy: 'andar1'),
  Item(nome:"cerâmica de sala-piso", type: mapItemTypeToProductType(ItemType.ceramicas), imagePath:"$_imageInitialPath/cerâmica_sala_piso.jpg", quantidade: 1, createdBy: 'andar1'),
  Item(nome:"cerâmica de banheiro piso", type:mapItemTypeToProductType(ItemType.maisPedidos), imagePath:"$_imageInitialPath/cerâmica_wc_piso.jpg", quantidade: 1, createdBy: 'andar1'),
  Item(nome:"cerâmica de banheiro-parede", type:mapItemTypeToProductType(ItemType.maisPedidos), imagePath:"$_imageInitialPath/cerâmica_wc_parede.png", quantidade: 1, createdBy: 'andar1'),
];
