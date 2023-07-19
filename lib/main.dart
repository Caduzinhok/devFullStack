import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importe o pacote

import 'analytics_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'wallet_page.dart';

void main() => runApp(const HomeAplicacaoFinanceira());

class HomeAplicacaoFinanceira extends StatelessWidget {
  const HomeAplicacaoFinanceira({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Definir a fonte padrão como Roboto
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: const BottomMenu(),
    );
  }
}

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() =>
      _BottomMenuState();
}

class _BottomMenuState
    extends State<BottomMenu> {
  
  // Por default abrir Home (Index 0)
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    // Desenvolver Pagina Inicial do Aplicativo
    HomeWidget(),

    // Desenvolver de Acompanhamento Analitico do Aplicativo
    AnalyticsWidget(),

   // Desenvolver tela de inserção de despesas e categorias do Aplicativo
    WalletWidget(),
    
    // Desenvolver Pagina de Configurações do Aplicativo
    AccountSettingsWallet(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, color: Colors.black),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet, color: Colors.black),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 97, 95, 93),
        onTap: _onItemTapped,
      ),
    );
  }
}


