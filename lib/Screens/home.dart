import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/utlity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/get_data_user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// Classe que representa os dados de cada categoria
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

class UserData {
  final String email;
  final String nome;
  UserData({required this.nome, required this.email});
}

class _HomeState extends State<Home> {
  List<PrincipalData> principalDataList = [];
  UserData ud = new UserData(nome: "", email: "");
  FirebaseFirestore firestoreEmail = FirebaseFirestore.instance;

  final List<String> day = [
    'Segunda',
    "Terça",
    "Quarta",
    "Quinta",
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Seu _head() widget com altura definida
            SizedBox(height: 340, child: _head()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Histórico de Transações',
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

            Expanded(
              // Aqui você pode colocar o seu FutureBuilder ou qualquer outra lista de conteúdos
              child: FutureBuilder<List<PrincipalData>>(
                future: getDataFromFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Erro ao buscar dados no Firebase: ${snapshot.error}'),
                    );
                  } else {
                    return getList(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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


  Widget getList(List<PrincipalData> principalDataList) {
    return ListView.builder(
      itemCount: principalDataList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            // Aqui você pode adicionar a lógica para excluir o item, se necessário.
            // principalDataList[index].delete();
          },
          child: get(principalDataList[index]),
        );
      },
    );
  }

  ListTile get(PrincipalData principalData) {
    return ListTile(
      title: Text(
        principalData.description,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${principalData.dataRegister.weekday - 1}  ${principalData.dataRegister.year}-${principalData.dataRegister.day}-${principalData.dataRegister.month}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            principalData.category,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      trailing: Text(
        principalData.amount.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: principalData.type == 'Renda' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _head() {
    return FutureBuilder<double>(
      future: totalLancamentos(),
      builder: (context, snapshot) {
        double valorTotal = snapshot.data ?? 0.0;
        return FutureBuilder<double>(
          future: Renda(),
          builder: (context, snapshotRenda) {
            double valorRenda = snapshotRenda.data ?? 0.0;

            return FutureBuilder<double>(
              future: Expenses(),
              builder: (context, snapshotRenda) {
                double valorDespesa = snapshotRenda.data ?? 0.0;

                return FutureBuilder<String?>(
                  future: getDisplayNameCurrentUser(),
                  builder: (context, snapshot) {
                    String nameUserLogged = snapshot.data ?? "0.0";
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
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 35,
                                    left: 340,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color:
                                            Color.fromRGBO(250, 250, 250, 0.1),
                                        child: Icon(
                                          Icons.notification_add_outlined,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Olá,',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 224, 223, 223),
                                          ),
                                        ),
                                        Text(
                                          '$nameUserLogged',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 140,
                          left: 37,
                          child: Container(
                            height: 170,
                            width: 320,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(47, 125, 121, 0.3),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                  spreadRadius: 6,
                                ),
                              ],
                              color: Color.fromARGB(255, 47, 125, 121),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Balanço Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 7),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        '\$ $valorTotal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor: Color.fromARGB(
                                                255, 85, 145, 141),
                                            child: Icon(
                                              Icons.arrow_downward,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Text(
                                            'Renda',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 216, 216, 216),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor: Color.fromARGB(
                                                255, 85, 145, 141),
                                            child: Icon(
                                              Icons.arrow_upward,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Text(
                                            'Despesas',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 216, 216, 216),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$ $valorRenda',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '\$ $valorDespesa',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
