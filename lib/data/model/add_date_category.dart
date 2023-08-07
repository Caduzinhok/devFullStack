import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/menu.dart';
import 'get_data_user.dart';

void saveToFirebaseCategory(BuildContext context, String name, String Description) async{
  String email = await getEmailNameCurrentUser();
  // Crie uma referência para a coleção "dados" no Cloud Firestore
  CollectionReference dataCollection = FirebaseFirestore.instance.collection('categorias');

  // Crie um mapa com os dados que deseja salvar
  var data = {
    'name': name,
    'description': Description,
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