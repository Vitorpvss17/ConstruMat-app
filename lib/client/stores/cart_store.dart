import 'package:construmatapp/models/item.dart';
import 'package:mobx/mobx.dart';


part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store{
  @observable
  List<Item> itemList = ObservableList<Item>();


  @computed
  int get quantidadeItem => itemList.length;

  @computed
  bool get emptyList => itemList.isEmpty;

  @action
  void addItemCart(Item item){
    itemList.add(item);
  }
  @action
  void removeItemCart(Item item){
    itemList.remove(item);
  }

  @action
  void clearCart(){
    itemList.clear();
  }
}