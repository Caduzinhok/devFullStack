import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  
Future<String> getDisplayNameCurrentUser() async {
    FirebaseFirestore firestoreEmail = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String name = "";

  if (user != null) {
    String userEmail = user.email!;
    try {
      final querySnapshot = await firestoreEmail
          .collection('cadastro')
          .where('email', isEqualTo: userEmail)
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        name = data['name'] as String;
      });

      print(name);
      return name;
    } catch (error) {
      print('Erro ao buscar dados: $error');
      return "";
    }
  } else {
      print('Nenhum usuário logado.');
      return name;
    }
  }

Future<String> getEmailNameCurrentUser() async {
    FirebaseFirestore firestoreEmail = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String email = "";

  if (user != null) {
    String userEmail = user.email!;
    try {
      final querySnapshot = await firestoreEmail
          .collection('cadastro')
          .where('email', isEqualTo: userEmail)
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        email = data['email'] as String;
      });

      print(email);
      return email;
    } catch (error) {
      print('Erro ao buscar dados: $error');
      return "";
    }
  } else {
      print('Nenhum email encontrado.');
      return email;
    }
  }
