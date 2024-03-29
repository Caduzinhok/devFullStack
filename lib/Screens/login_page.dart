import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:managment/Screens/forgot_password.dart';
import 'package:managment/Screens/register_page.dart';
import 'package:managment/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:managment/Services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
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
          builder: (context) => Bottom(),
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
  
  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;
  FocusNode em = FocusNode();
  FocusNode sen = FocusNode();

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Entrar';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(emailController.text, passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Bottom(), // Substitua "NextScreen" pelo nome da próxima tela.
        ),
      );
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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
          textLogin(),
          SizedBox(height: 30),
          setEmail(),
          SizedBox(height: 30),
          setSenha(),
          SizedBox(height: 30),
          save(),
          SizedBox(height: 30),
          textButton(),
          SizedBox(height: 30),
          textButton2(),
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

  Padding setSenha() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: true,
        focusNode: sen,
        controller: passwordController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Senha',
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
  Padding textButton(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextButton(
          onPressed: () {
            // Ação ao pressionar o TextButton
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
            isLogin = false;
          },
          child: Text('Ainda não tem conta? Cadastre-se agora.'),
        ),
    );
  }

  Padding textLogin(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Color(0xff368983), fontWeight: FontWeight.bold),
        ),
    );
  }
  Padding textButton2(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          // Ação ao pressionar o TextButton
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          );
          isLogin = false;
        },
        child: Text('Esqueci minha senha'),
      ),
    );
  }

  Padding save() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
            setFormAction(!isLogin);
            login();
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
                actionButton,
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
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'FinanceHub',
                    style: TextStyle(color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
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

