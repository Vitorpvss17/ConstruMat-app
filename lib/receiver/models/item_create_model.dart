import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/admin/models/product_type.dart';
import 'package:construmatapp/models/item.dart';
import 'package:construmatapp/receiver/models/items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../admin/models/types.dart';

class ItemCreationModel {
  final User currentUser;

  ItemCreationModel({required this.currentUser});

  Future<void> createItem(BuildContext context, {required VoidCallback onSaved}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    late File arquivo = File('');
    final picker = ImagePicker();
    late BuildContext dialogContext;

    Future getFileFromGallery(ImageSource source) async {
      final file = await picker.pickImage(source: source);

      if (file != null) {
        arquivo = File(file.path);
      }
    }

    TextEditingController nomeInput = TextEditingController();
    TextEditingController quantidadeInput = TextEditingController();
    Types typesProvider = context.read<Types>();
    ProductType dropdownValue = typesProvider.types[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          scrollable: true,
          title: const Text('Cadastrar Item'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nomeInput,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
                    controller: quantidadeInput,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      icon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => getFileFromGallery(ImageSource.gallery),
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Selecione um arquivo'),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton<String?>(
                        isExpanded: true,
                        value: dropdownValue.name,
                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.indigo,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = typesProvider.types
                                .firstWhere((type) => type.name == newValue, orElse: () => typesProvider.types[0]);
                          });
                        },
                        items: typesProvider.types.map((ProductType type) {
                          return DropdownMenuItem<String?>(
                            value: type.name,
                            child: Text(type.name),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Consumer<Items>(
              builder: (BuildContext context, Items list, Widget? widget) {
                return TextButton(
                  child: const Text("Salvar"),
                  onPressed: () async {
                    int quantidade = 1;
                    try {
                      quantidade = int.parse(quantidadeInput.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao converter quantidade: $e'),
                        ),
                      );
                      return;
                    }

                    String imagePath = arquivo.path.isNotEmpty
                        ? arquivo.path
                        : 'assets/images/massa_emboço.jpg';

                    Item newItem = Item(
                      id: const Uuid().v4(),
                      nome: nomeInput.text,
                      type: dropdownValue,
                      imagePath: imagePath,
                      quantidade: quantidade,
                      createdBy: currentUser.uid,
                    );



                    await firestore.collection('items').doc(newItem.id).set(newItem.toMap());

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item criado com sucesso!'),
                      ),
                    );
                    Navigator.pop(dialogContext);
                    onSaved();
                  },
                );
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}