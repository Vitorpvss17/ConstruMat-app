// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItemStore on _ItemStore, Store {
  late final _$valorCounterAtom =
      Atom(name: '_ItemStore.valorCounter', context: context);

  @override
  int get valorCounter {
    _$valorCounterAtom.reportRead();
    return super.valorCounter;
  }

  @override
  set valorCounter(int value) {
    _$valorCounterAtom.reportWrite(value, super.valorCounter, () {
      super.valorCounter = value;
    });
  }

  late final _$_ItemStoreActionController =
      ActionController(name: '_ItemStore', context: context);

  @override
  void addItem() {
    final _$actionInfo =
        _$_ItemStoreActionController.startAction(name: '_ItemStore.addItem');
    try {
      return super.addItem();
    } finally {
      _$_ItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem() {
    final _$actionInfo =
        _$_ItemStoreActionController.startAction(name: '_ItemStore.removeItem');
    try {
      return super.removeItem();
    } finally {
      _$_ItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valorCounter: ${valorCounter}
    ''';
  }
}
