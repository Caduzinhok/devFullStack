import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managment/Screens/home.dart';
import 'package:managment/Screens/statistics.dart';
import '../widgets/menu.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Bottom(), // Substitua "NextScreen" pelo nome da próxima tela.
        ),
      );
      // Login bem-sucedido, você pode navegar para a próxima tela aqui.
    } catch (e) {
      print('Erro ao fazer login: $e');
      // Trate erros de autenticação aqui (por exemplo, exiba uma mensagem de erro na tela).
    }
  }
  void _createAccountWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Bottom(), // Substitua "NextScreen" pelo nome da próxima tela.
        ),
      );

      // Conta de usuário criada com sucesso, você pode navegar para a próxima tela aqui.
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          print('Este e-mail já está em uso. Por favor, tente outro.');
          // Exiba uma mensagem de erro na tela informando que o e-mail já está em uso.
        } else if (e.code == 'weak-password') {
          print('Senha fraca. A senha deve ter pelo menos 6 caracteres.');
          // Exiba uma mensagem de erro na tela informando que a senha é fraca.
        } else {
          print('Erro ao criar conta: ${e.message}');
          // Trate outras exceções do FirebaseAuthException conforme necessário.
        }
      } else {
        print('Erro ao criar conta: $e');
        // Trate outras exceções que não sejam do tipo FirebaseAuthException.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(context),
              child: Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: () => _createAccountWithEmailAndPassword(context),
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
