import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

// Classe que representa os dados de cada categoria
class CategoryData {
  final String name;
  final String description;

  CategoryData({required this.name, required this.description});
}

class _CategoryState extends State<Category> {
  var history;

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: FutureBuilder<List<CategoryData>>(
    future: getDataFromFirebase(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Erro ao carregar os dados'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: Text('Nenhum dado encontrado'),
        );
      } else {
        return CustomScrollView(
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
                      'Histórico de Categorias',
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
                  CategoryData categoryData = snapshot.data![index];
                  return ListTile(
                    title: Text(
                      categoryData.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
                childCount: snapshot.data!.length,
              ),
            )
          ],
        );
      }
    },
  ),
);
  }

  Future<List<CategoryData>> getDataFromFirebase() async {
    List<CategoryData> categoryList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categorias').get();

      querySnapshot.docs.forEach((doc) {
        // Recupera os dados do documento e cria uma instância de CategoryData
        CategoryData categoryData = CategoryData(
          name: doc['name'],
          description: doc['description'],
        );

        // Adiciona o CategoryData à lista
        categoryList.add(categoryData);
      });

      return categoryList;
    } catch (e) {
      print('Erro ao buscar dados no Firebase: $e');
      return [];
    }
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
