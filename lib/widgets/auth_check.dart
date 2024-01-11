import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construmatapp/models/custom_user.dart';
import 'package:construmatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserType {
  Solicitante,
  Recebedor,
  Administrador,
}

class Result<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  Result.success(this.data) : isSuccess = true, error = null;
  Result.failure(this.error) : isSuccess = false, data = null;
}

class AuthCheck extends StatelessWidget {
  final PageRouteBuilder solicitanteScreen;
  final PageRouteBuilder receiverScreen;
  final PageRouteBuilder admScreen;
  final PageRouteBuilder loginScreen;

  const AuthCheck({
    Key? key,
    required this.solicitanteScreen,
    required this.receiverScreen,
    required this.admScreen,
    required this.loginScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return _buildContent(authService);
      },
    );
  }

  Widget _buildContent(AuthService authService) {
    if (authService.isLoading) {
      return const CircularProgressIndicator();
    } else {
      final usuario = authService.usuario;
      if (usuario != null) {
        return FutureBuilder<UserType?>(
          future: getTipoConta(usuario),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              final userType = snapshot.data;
              if (userType != null) {
                Future.delayed(Duration.zero, () {
                  switch (userType) {
                    case UserType.Solicitante:
                      Navigator.pushReplacement(context, solicitanteScreen);
                      break;
                    case UserType.Recebedor:
                      Navigator.pushReplacement(context, receiverScreen);
                      break;
                    case UserType.Administrador:
                      Navigator.pushReplacement(context, admScreen);
                      break;
                    default:
                      break;
                  }
                });
              } else {
                return Container();
              }
            }

            return Container();
          },
        );
      } else {
        return Navigator(onGenerateRoute: (_) => loginScreen);
      }
    }
  }

  Future<UserType?> getTipoConta(CustomUser user) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        String tipoConta = doc['tipoConta'].toString().toLowerCase().trim();
        UserType? userType = UserType.values.firstWhereOrNull(
              (type) => type.toString().split('.').last.toLowerCase() == tipoConta,
        );
        if (userType != null) {
          return userType;
        } else {
          return UserType.Solicitante;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}