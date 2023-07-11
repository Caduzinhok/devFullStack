import 'package:flutter/material.dart';


class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Exibir aqui a tela de relatórios e analytics do aplicativo',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }
}