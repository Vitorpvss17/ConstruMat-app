import 'package:construmatapp/client/components/notification_widget.dart';
import 'package:construmatapp/helpers/fetch_pedido_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../admin/models/types.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    OrderHelper orderHelper = OrderHelper(context.read<Types>(), context, user!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: NotificationScreen(orderHelper: orderHelper),
    );
  }
}