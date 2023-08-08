import 'package:flutter/material.dart';
import 'package:managment/data/utlity.dart';
import 'package:managment/widgets/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/model/get_data_user.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class PrincipalData {
  final String category;
  final String description;
  final String amount;
  final String type;
  final DateTime dataRegister;
  PrincipalData(
      {required this.category,
      required this.description,
      required this.type,
      required this.amount,
      required this.dataRegister});
}

ValueNotifier kj = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  List day = ['Dia', 'Semana', 'Mês', 'Ano'];
  List f = [today(), week(), month(), year()];
  int index_color = 0;
  List<PrincipalData> principalDataList = [];

  Future<List<PrincipalData>> getDataFromFirebase() async {
    try {
      String? email = await getEmailNameCurrentUser();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('lancamentos')
          .where('email', isEqualTo: email)
          .get();

      List<PrincipalData> principalDataList = [];

      querySnapshot.docs.forEach((doc) {
        // Recupera os dados do documento e cria uma instância de PrincipalData
        PrincipalData principalData = PrincipalData(
          category: doc['category'],
          description: doc['description'],
          type: doc['type'],
          amount: doc['amount'],
          dataRegister: (doc['dataRegister'] as Timestamp).toDate(),
        );

        // Adiciona o PrincipalData à lista
        principalDataList.add(principalData);
        print("Dados Salvos");
      });

      return principalDataList;
    } catch (e) {
      print('Error fetching data from Firebase: $e');
      return []; // Return an empty list in case of an error
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: FutureBuilder<List<PrincipalData>>(
        future: getDataFromFirebase(),
        builder: (BuildContext context, AsyncSnapshot<List<PrincipalData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error fetching data'); // Display an error message if data fetch fails
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available'); // Display a message if there's no data
          } else {
            principalDataList = snapshot.data!; // Assign fetched data to the list
            return ValueListenableBuilder(
              valueListenable: kj,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return custom();
              },
            );
          }
        },
      ),
    ),
  );
}

  CustomScrollView custom() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Relatório Estatístico',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              index_color = index;
                              kj.value = index;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index_color == index
                                  ? Color.fromARGB(255, 47, 125, 121)
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Chart(
                index: index_color,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Gastos',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListTile(
              title: Text(
                principalDataList[index].description,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                ' ${principalDataList[index].dataRegister.year}-${principalDataList[index].dataRegister.day}-${principalDataList[index].dataRegister.month}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                principalDataList[index].amount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: principalDataList[index].type == 'Renda' ? Colors.green : Colors.red,
                ),
              ),
            );
          },
          childCount: principalDataList.length,
        ))
      ],
    );
  }
}
