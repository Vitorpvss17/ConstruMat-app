import 'dart:async';

import 'package:construmatapp/helpers/fetch_pedido_firebase.dart';
import 'package:construmatapp/models/pedido.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final OrderHelper orderHelper;

  const NotificationScreen({super.key, required this.orderHelper});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Timer timer;
  late Future<List<Pedido>> notificationData;

  @override
  void initState() {
    super.initState();
    initializeTimer();
    refreshNotifications();
  }

  void initializeTimer() {
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      refreshNotifications();
    });
  }

  void refreshNotifications() {
    setState(() {
      notificationData = widget.orderHelper.fetchPedidosFromFirebase();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pedido>>(
      future: notificationData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Pedido> notifications = snapshot.data ?? [];
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Pedido notification = notifications[index];
              return ListTile(
                title: Text('Solicitante: ${notification.nomeSolicitante}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notification.itens.map((item) {
                    return Text('${item.nome} - ${item.quantidade}');
                  }).toList(),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (notification.status == StatusPedido.aprovado)
                      const Icon(Icons.check, color: Colors.green),
                    if (notification.status == StatusPedido.recusado)
                      const Icon(Icons.close, color: Colors.red),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}