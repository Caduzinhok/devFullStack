import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managment/Screens/category.dart';

void saveToFirebase(BuildContext context, String name, String Description) {
  // Crie uma referência para a coleção "dados" no Cloud Firestore
  CollectionReference dataCollection = FirebaseFirestore.instance.collection('categoria');

  // Crie um mapa com os dados que deseja salvar
  var data = {
    'name': name,
    'description': Description,
  };

  // Adicione os dados à coleção no Firebase
  dataCollection.add(data)
    .then((value) {
      print('Dados salvos com sucesso no Firebase! Document ID: ${value.id}');
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Category(),
        ),
  );
    })
    .catchError((error) {
      print('Erro ao salvar os dados no Firebase: $error');
    });
}