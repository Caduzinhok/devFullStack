import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/Screens/login_page.dart';
import 'package:managment/data/model/get_data_user.dart';
import 'package:provider/provider.dart';
import 'package:managment/Services/auth_service.dart';
import 'package:managment/widgets/menu.dart';
import 'package:managment/Screens/settings.dart' as app_settings;
import '../data/model/add_date_new_register.dart';

final User? user = FirebaseAuth.instance.currentUser;

class EditPage extends StatefulWidget {
  EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  FocusNode em = FocusNode();
  FocusNode sen = FocusNode();
  FocusNode nam = FocusNode();


  @override
  void initState() {
    super.initState();
    emailController.text = emailUser;
    nameController.text = nameUser;
  }


  update() async {
    final _auth = FirebaseAuth.instance;
    setState(() => loading = true);
    try {
      if(nameController.text.isNotEmpty || emailController.text.isNotEmpty){
        await FirebaseFirestore.instance.collection('cadastro').doc(documentId).update({
          'name': nameController.text,
          'email': emailController.text,
        });
      }
      if(emailController.text.isNotEmpty){
        await _auth.currentUser?.updateEmail(emailController.text);
      }
      if(passwordController.text.isNotEmpty){
        await _auth.currentUser?.updatePassword(passwordController.text);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => app_settings.Settings(), // Substitua "NextScreen" pelo nome da próxima tela.
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
          setName(),
          SizedBox(height: 30),
          setEmail(),
          SizedBox(height: 30),
          setPassword(),
          SizedBox(height: 30),
          save(),
          SizedBox(height: 30),
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

  Padding setName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.text,
        focusNode: nam,
        controller: nameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Nome',
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

  Padding setPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.text,
        focusNode: nam,
        obscureText: true,
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
            MaterialPageRoute(builder: (context) => app_settings.Settings()),
          );
        },
        child: Text('Voltar à tela de configurações'),
      ),
    );
  }
  Padding save() {
    return Padding(
      padding: EdgeInsets.all(24.0),

      child: ElevatedButton(
        onPressed: () {
          update();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => app_settings.Settings()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados atualizados com sucesso!')),
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
                'Salvar',
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
                      'Atualização de cadastro',
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

