import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managment/Screens/login_page.dart';
import 'package:managment/Screens/register_page.dart';
import 'package:managment/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:managment/Services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  bool loading = false;
  FocusNode em = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'E-mail de redefinição de senha enviado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar o e-mail de redefinição: $e')),
      );
    }
  }

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
          info(),
          SizedBox(height: 5),
          setEmail(),
          SizedBox(height: 20),
          save(),
          SizedBox(height: 20),
          textButton(),
        ],
      ),
    );
  }

  Padding setEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        focusNode: em,
        controller: emailController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xff368983))),
        ),
      ),
    );
  }

  Padding info() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
       'Insira o e-mail para recuperação da sua senha.',
        style: TextStyle(fontSize: 14, color: Color(0xff368983), fontWeight: FontWeight.w800),
      ),
    );
  }

  Padding textButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          // Ação ao pressionar o TextButton
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Text('Voltar ao login'),
      ),
    );
  }

  Padding save() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
          _resetPassword(context);
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
          children: (loading)
              ? [
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          ]
              : [
            Icon(Icons.check),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Redefinir senha',
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
                      'Redefinição de senha',
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

