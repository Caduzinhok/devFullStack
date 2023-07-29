import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/utlity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class CategoryFB {
  String? id;
  String? name;
  String? type;

  CategoryFB({required this.id, required this.name, required this.type});

  // Método para converter a classe para um mapa (para salvar no Firestore).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

void saveCategoryFB(CategoryFB categoria) async {
  try {
    CollectionReference categoriasRef = FirebaseFirestore.instance.collection('categorias');

    // Converte a classe Categoria para um mapa usando o método toMap().
    Map<String, dynamic> categoriaData = categoria.toMap();

    // Salva a categoria no Firestore usando o método add().
    await categoriasRef.add(categoriaData);
    print('Categoria salva com sucesso!');
  } catch (e) {
    print('Erro ao salvar a categoria: $e');
  }
}

Future<List<CategoryFB>> getCategoriesFB() async {
  try {
    CollectionReference categoriasRef = FirebaseFirestore.instance.collection('categorias');

    // Obtém todos os documentos da coleção usando o método get().
    QuerySnapshot querySnapshot = await categoriasRef.get();

    // Converte os documentos em objetos Categoria.
    List<CategoryFB> categorias = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        categorias.add(CategoryFB(
          id: doc.id,
          name: data['name'],
          type: data['type'],
        ));
      }
    });

    return categorias;
  } catch (e) {
    print('Erro ao obter as categorias: $e');
    return [];
  }
}



class _CategoryState extends State<Category> {
  List<CategoryFB> categorias = []; // Lista para armazenar as categorias do Firestore.

  @override
  void initState() {
    super.initState();
    getCategoriasFromFirestore(); // Chama a função para obter as categorias do Firestore.
  }

  void getCategoriasFromFirestore() async {
    List<CategoryFB> categoriasFromFirestore = await getCategoriesFB();
    setState(() {
      categorias = categoriasFromFirestore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 340, child: _head()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorias Existentes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Ver Tudo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  CategoryFB categoria = categorias[index];
                  return getList(categoria, index);
                },
                childCount: categorias.length,
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget getList(CategoryFB category, int index) {
    Add_data history = Add_data.fromCategory(category);
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // Remove o item do Hive e atualiza a interface do usuário.
        setState(() {
          box.deleteAt(index);
        });
      },
      child: get(index, history),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }


  ListTile get(int index, Add_data history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset('images/${history.name}.png', height: 40),
      ),
      title: Text(
        history.name,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
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
            ),
          ],
        ),  
      ],
    );
  }
}
