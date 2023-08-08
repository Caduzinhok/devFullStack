import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managment/Screens/home.dart';
import 'package:managment/Services/auth_service.dart';
import 'package:managment/data/model/get_data_user.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

ValueNotifier kj = ValueNotifier(0);

class _SettingsState extends State<Settings> {
  User? _user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: 120,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 550,
      width: 340,
      child: Column(
        children: [
          SizedBox(height: 50),
          infoUser(),
          SizedBox(height: 30),
          logout_button(),
        ],
      ),
    );
  }
  Widget infoUser(){
    return FutureBuilder<String?>(
      future: getDisplayNameCurrentUser(),
      builder: (context, snapshot) {
        String nameUserLogged = snapshot.data ?? "0.0";
        return FutureBuilder<String?>(
          future: getEmailNameCurrentUser(),
          builder: (context, snapshotEmail) {
            String emailUserLogged = snapshotEmail.data ?? "0.0";
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Meus dados',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ]
                  ),

                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 24),
                  child: Row(
                    children: [
                      Text(
                        'Nome: ' + '$nameUserLogged',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 80, left: 24),
                  child: Row(
                    children: [
                      Text(
                        'Email: ' + '$emailUserLogged',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      }
      );
  }
  void fazerLogout() async {
    AuthService authService = AuthService(); // instância da classe AuthService

    try {
      await authService.logout(); // Chame o método logout() na instância criada
      print('Usuário deslogado com sucesso.');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  Padding logout_button() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
          fazerLogout();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff368983), // Cor verde definida por hexadecimal
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Fazer Logout',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Configurações',
                      style: TextStyle(fontSize: 20.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

}