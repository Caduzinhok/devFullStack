import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  
Future<String?> getDisplayNameCurrentUser() async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email ?? '';

      // Acesse o documento do usuário na coleção "cadastro" usando o email como filtro de consulta
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('cadastro')
          .where('email', isEqualTo: userEmail)
          .get();

      // Verifica se o documento com o email do usuário existe e é único
      if (snapshot.size == 1) {
        // Obtém o nome do usuário a partir do documento
        String? nomeUsuario = snapshot.docs[0].data()['nome'];
        String? emailUsuario = snapshot.docs[0].data()['email'];

        return nomeUsuario;

      } else {
        // O email do usuário logado não foi encontrado ou não é único na coleção "cadastro"
        return "";
      }
    } else {
      // O usuário não está logado
      return "";
    }
  } catch (e) {
    // Trate possíveis erros (opcional)
    print('Erro ao obter o nome do usuário logado: $e');
    return null;
  }
  }

Future<String?> getEmailNameCurrentUser() async {
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
