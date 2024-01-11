import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/admin/models/types.dart';
import 'package:construmatapp/client/components/cartao.dart';
import 'package:construmatapp/client/components/categoria_text.dart';
import 'package:construmatapp/client/components/search_input.dart';
import 'package:construmatapp/client/screens/checkout.dart';
import 'package:construmatapp/client/screens/notification_screen.dart';
import 'package:construmatapp/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../admin/models/product_type.dart';
import '../../services/auth_service.dart';
import '../stores/cart_store.dart';

class SolicitanteScreen extends StatefulWidget {
  const SolicitanteScreen({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<SolicitanteScreen> createState() => _SolicitanteScreenState();
}

class _SolicitanteScreenState extends State<SolicitanteScreen> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Types typesProvider = Provider.of<Types>(context);
    ProductType maisPedidos = typesProvider.types[0];
    ProductType massas = typesProvider.types[1];
    ProductType ceramicas = typesProvider.types[2];
    final BuildContext homeContext = context;
    final cartStore = Provider.of<CartStore>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              color: Colors.black,
            ),
          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
              icon: const Icon(Icons.notifications),
            ),
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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SearchInput(
                searchTextController: searchTextController,
              ),
            ),
            _buildCategoryListView("Mais pedidos", maisPedidos.name),
            _buildCategoryListView("massas", massas.name),
            _buildCategoryListView("cerâmicas", ceramicas.name),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Observer(
                  builder: (_) => !cartStore.emptyList
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Checkout(
                                  homeContext: homeContext,
                                  onOrderPlaced: () {
                                    cartStore.clearCart();
                                  }, user: widget.user,
                                );
                              }),
                            );
                          },
                          child: Ink(
                            width: double.infinity,
                            height: 80,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceTint,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          "${cartStore.quantidadeItem}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.shopping_basket_outlined,
                                        size: 24,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Ver carrinho",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryListView(String title, String category) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CategoriaText(titulo: title),
          SizedBox(
            height: 150,
            child: FutureBuilder<List<Item>>(
              future: fetchItemsFromFirebase(category: category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Item> items = snapshot.data ?? [];
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: items
                        .map<Widget>((item) => Cartao(item: item))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Item>> fetchItemsFromFirebase({String? category}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot;

      if (category != null) {
        querySnapshot = await firestore
            .collection('items')
            .where('type.name', isEqualTo: category)
            .get();
      } else {
        querySnapshot = await firestore.collection('items').get();
      }

      List<Item> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String categoryName = data['type']['name'];
        return Item(
          nome: data['nome'],
          quantidade: data['quantidade'],
          imagePath: data['imagePath'],
          type: ProductType(name: categoryName),
          createdBy: widget.user.uid,
        );
      }).toList();

      return items;
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
