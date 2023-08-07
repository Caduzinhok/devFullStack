import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/menu.dart';
import 'get_data_user.dart';

void saveToFirebasePrincipal(BuildContext context, String category, String description, String amount, String type, DateTime dataRegister) async{
  // Crie uma referência para a coleção "dados" no Cloud Firestore
  String email = await getEmailNameCurrentUser();

  CollectionReference dataCollection = FirebaseFirestore.instance.collection('lancamentos');

  // Crie um mapa com os dados que deseja salvar
  var data = {
    'category': category,
    'description': description,
    'amount': amount,
    'type': type,
    'dataRegister': Timestamp.fromDate(dataRegister),
    'email': email,
  };

  // Adicione os dados à coleção no Firebase
  dataCollection.add(data)
    .then((value) {
      print('Dados salvos com sucesso no Firebase! Document ID: ${value.id}');
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bottom(),
        ),
  );
    })
    .catchError((error) {
      print('Erro ao salvar os dados no Firebase: $error');
    });
}