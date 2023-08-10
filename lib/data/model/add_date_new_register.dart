import 'package:cloud_firestore/cloud_firestore.dart';



void saveToFirebaseRegister(String name, String email) async {
  // Crie uma referência para a coleção "dados" no Cloud Firestore
  CollectionReference dataCollection = FirebaseFirestore.instance.collection('cadastro');

  // Crie um mapa com os dados que deseja salvar
  var data = {
    'name': name,
    'email': email,
  };

  // Adicione os dados à coleção no Firebase
  dataCollection.add(data)
    .then((value) {
      print('Dados salvos com sucesso no Firebase! Document ID: ${value.id}');      
    })
    .catchError((error) {
      print('Erro ao salvar os dados no Firebase: $error');
    });
}