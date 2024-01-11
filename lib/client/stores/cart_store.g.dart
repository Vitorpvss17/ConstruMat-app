// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  Computed<int>? _$quantidadeItemComputed;

  @override
  int get quantidadeItem =>
      (_$quantidadeItemComputed ??= Computed<int>(() => super.quantidadeItem,
              name: '_CartStore.quantidadeItem'))
          .value;
  Computed<bool>? _$emptyListComputed;

  @override
  bool get emptyList => (_$emptyListComputed ??=
          Computed<bool>(() => super.emptyList, name: '_CartStore.emptyList'))
      .value;

  late final _$itemListAtom =
      Atom(name: '_CartStore.itemList', context: context);

  @override
  List<Item> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(List<Item> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  void addItemCart(Item item) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.addItemCart');
    try {
      return super.addItemCart(item);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItemCart(Item item) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.removeItemCart');
    try {
      return super.removeItemCart(item);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemList: ${itemList},
quantidadeItem: ${quantidadeItem},
emptyList: ${emptyList}
    ''';
  }
}
