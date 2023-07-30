import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managment/Screens/login_page.dart';
import '../widgets/menu.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String MessageError = "";
   void _showErrorAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ERRO',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(MessageError),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'FECHAR',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.red, width: 2),
          ),
        );
      },
    );
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
          builder: (context) => Bottom(), 
        ),
      );

      // Conta de usuário criada com sucesso, você pode navegar para a próxima tela aqui.
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          MessageError = 'Este e-mail já está em uso. Por favor, tente outro.';
          // Exiba uma mensagem de erro na tela informando que o e-mail já está em uso.
        } else if (e.code == 'weak-password') {
          MessageError = 'Senha fraca. A senha deve ter pelo menos 6 caracteres.';
          // Exiba uma mensagem de erro na tela informando que a senha é fraca.
        } else {
          print('Erro ao criar conta: ${e.message}');
          MessageError = 'Erro ao criar conta, por favor tente novamente';
          // Trate outras exceções do FirebaseAuthException conforme necessário.
        }
        _showErrorAlert(context);
      } else {
        print('Erro ao criar conta: $e');
        MessageError = 'Erro ao criar conta, por favor tente novamente';
        // Trate outras exceções que não sejam do tipo FirebaseAuthException.
        _showErrorAlert(context);
      }
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  Color(0xff368983),
                borderRadius: BorderRadius.circular(8),
              ),
              
              child: Column(
                children: [
                  Text(
                     'Registre-se Agora',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 34),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white,),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'E-mail', labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white,),
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Senha', labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white)
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                        _createAccountWithEmailAndPassword(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 0,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Registrar-se',
                          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                          child: Text(
                            'Já Possuo Conta',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16, // Increase font size when cursor enters
                              decoration: TextDecoration.underline,
                            ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
