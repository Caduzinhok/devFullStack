import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managment/Screens/register_page.dart';
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
      _showErrorAlert(context);
      // Trate erros de autenticação aqui (por exemplo, exiba uma mensagem de erro na tela).
    }
  }

    void _showErrorAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ERRO',
            style: TextStyle(color: Colors.red),
          ),
          content: Text('Usuário ou senha incorreto, por favor verifique.'),
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
                     'Entre agora',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'E-mail', labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white,),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Senha', labelStyle: TextStyle(color: Colors.white) ),
                    style: TextStyle(color: Colors.white)
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _signInWithEmailAndPassword(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          padding: EdgeInsets.all(16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Entrar',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 0,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Criar Conta',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
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
