import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddCategoryScreen(),
    );
  }
}

class Category {
  final String name;

  Category(this.name);
}


class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  final TextEditingController _categoryController = TextEditingController();
  final List<Category> _categories = [];

  void _deleteCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  void _saveCategory() {
    String categoryName = _categoryController.text;
    if (categoryName.isNotEmpty) {
      Category newCategory = Category(categoryName);
      _databaseReference.child('categories').push().set({
        'name': newCategory.name,
      }).then((_) {
        setState(() {
          _categories.add(newCategory);
        });
        _categoryController.clear();
        Navigator.pop(context);
      });
    }
  }

  void _showAddCategoryModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Nome da Categoria',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveCategory,
                child: Text('Adicionar Categoria'),
              ),
            ],
          ),
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Categorias Adicionadas',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(1.0), // Aumenta o espaçamento interno
                          margin: EdgeInsets.symmetric(vertical: 4.0), // Aumenta o espaçamento entre as categorias
                          decoration: BoxDecoration(
                            color: Color(0xAE397E7B), // Define o background verde
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              _categories[index].name,
                              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 255, 255),),
                              onPressed: () => _deleteCategory(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.0),
            FloatingActionButton(
              onPressed: _showAddCategoryModal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                ],
              ),
              mini: true, // Diminui o tamanho do botão
            ),
          ],
        ),
      ),
    );
  }
}
