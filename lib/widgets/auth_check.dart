import 'package:flutter/material.dart';
import '../Screens/login_page.dart';
import '../Services/auth_service.dart';
import '../widgets/menu.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}
class _AuthCheckState extends State<AuthCheck>{
  @override
  Widget build(BuildContext context){
    AuthService auth = Provider.of<AuthService>(context);
    if(auth.isLoading) return loading();
    else if(auth.user == null) return LoginPage();
    else return Bottom();
  }

  loading(){
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}