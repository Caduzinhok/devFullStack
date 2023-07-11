import 'package:flutter/material.dart';


class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Exibir aqui a tela inicial do aplicativo',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }
}