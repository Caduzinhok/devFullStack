import 'package:flutter/material.dart';


class AccountSettingsWallet extends StatelessWidget {
  const AccountSettingsWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Exibir aqui a tela de configurações do usuário',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }
}