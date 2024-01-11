import 'package:construmatapp/components/product_menu.dart';
import 'package:construmatapp/models/pedido.dart';
import 'package:construmatapp/receiver/models/item_create_model.dart';
import 'package:construmatapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin/models/types.dart';
import '../../helpers/fetch_pedido_firebase.dart';


class ReceiverScreen extends StatefulWidget {
  const ReceiverScreen({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User? user;

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  late OrderHelper orderHelper;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    orderHelper = OrderHelper(context.read<Types>(), context, widget.user!.uid);
    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthService>().logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.logout),
            color: Colors.red,
          )
        ],
      ),
      drawer: const ProductMenu(),
      body: FutureBuilder<List<Pedido>>(
        future: orderHelper.fetchPedidosFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Pedido> pedidos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                Pedido pedido = pedidos[index];
                return Dismissible(
                  key: Key(pedido.nomeSolicitante),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await orderHelper.updatePedidoStatus(
                          pedido.id, StatusPedido.recusado);
                      setState(() {
                        pedidos.removeAt(index);
                      });
                    } else if (direction == DismissDirection.startToEnd) {
                      await orderHelper.updatePedidoStatus(
                          pedido.id, StatusPedido.aprovado);
                      setState(() {
                        pedidos.removeAt(index);
                      });
                    }
                  },
                  child: ListTile(
                    title: Text('Solicitante: ${pedido.nomeSolicitante}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pedido.itens.map((item) {
                        return Text(
                          '${item.nome} - ${item.quantidade}',
                        );
                      }).toList(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (pedido.status == StatusPedido.aprovado)
                          const Icon(Icons.check, color: Colors.green),
                        if (pedido.status == StatusPedido.recusado)
                          const Icon(Icons.close, color: Colors.red),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          ItemCreationModel itemCreationModel = ItemCreationModel(currentUser: _currentUser!);
          itemCreationModel.createItem(context, onSaved: () {});
        },
        tooltip: 'Add Tipo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
