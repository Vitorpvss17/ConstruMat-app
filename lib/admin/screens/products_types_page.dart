import 'package:construmatapp/admin/models/product_type.dart';
import 'package:construmatapp/admin/models/types.dart';
import 'package:construmatapp/components/product_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/icon_picker.dart';

class ProductTypePage extends StatefulWidget {
  const ProductTypePage({super.key, required this.title});
  final String title;

  @override
  State<ProductTypePage> createState() => _ProductTypePageState();
}

class _ProductTypePageState extends State<ProductTypePage> {
  IconData? selectedIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const ProductMenu(),
      body: Consumer<Types>(builder: (BuildContext context, Types list, Widget? widget){
        return ListView.builder(
          itemCount: list.types.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(list.types[index].name),
                iconColor: Colors.deepOrange,
              ),
              onDismissed: (direction) {
                list.remove(index);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: (){createType(context);},
        tooltip: 'Add Tipo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void createType(context) {
    TextEditingController nomeInput = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Cadastrar tipo'),
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
                    StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return Column(children: [
                        const Padding(padding: EdgeInsets.all(5)),
                        selectedIcon != null ? Icon(selectedIcon, color: Colors.deepOrange) : const Text('Selecione um ícone'),
                        const Padding(padding: EdgeInsets.all(5)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                final IconData? result = await showIconPicker(context: context, defalutIcon: selectedIcon);
                                setState(() {
                                  selectedIcon = result;
                                });
                              },
                              child: const Text('Selecionar icone')
                          ),
                        ),
                      ]);
                    }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    selectedIcon ??= Icons.credit_score;
                    Provider.of<Types>(context, listen: false).add(ProductType(name: nomeInput.text));
                    selectedIcon = null;
                    Navigator.pop(context);
                  }
              ),
              TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () async {
                    selectedIcon = null;
                    Navigator.pop(context);
                  }
              )
            ],
          );
        }
    );
  }
}
