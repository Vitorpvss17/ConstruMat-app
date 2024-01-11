import 'package:mobx/mobx.dart';

part 'item_store.g.dart';

class ItemStore = _ItemStore with _$ItemStore;



abstract class _ItemStore with Store{
  @observable
  int valorCounter = 0;

  @action
  void addItem(){
    valorCounter++;
  }
  @action
  void removeItem(){
    valorCounter--;
  }
}