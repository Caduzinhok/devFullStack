import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}
class _CategoryState extends State<Category> {


  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [

            ],
          ),
        ),
      );
    }
  }