import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/item.dart';

class Items extends ChangeNotifier {
  List<Item> items;

  Items({
    required this.items,
  });

  void add(Item item, [DocumentReference<Map<String, dynamic>>? doc]) {
    items.add(item);
    notifyListeners();
  }

  Future<void> remove(Item item) async {
    items.remove(item);
    notifyListeners();
  }
}