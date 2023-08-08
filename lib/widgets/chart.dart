import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../data/model/get_data_user.dart';
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

class Chart extends StatefulWidget {
  int index;
  Chart({Key? key, required this.index}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Add_data>? a;
  List<PrincipalData> principalDataList = [];

  bool b = true;
  bool j = true;

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

bool isWithinYear(DateTime date1, DateTime date2) {
  return date1.year == date2.year;
}

bool isWithinMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}

bool isWithinWeek(DateTime date1, DateTime date2) {
  final difference = date1.difference(date2).inDays.abs();
  return difference <= 7;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

@override
Widget build(BuildContext context) {
  return FutureBuilder<List<PrincipalData>>(
    future: getDataFromFirebase(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error fetching data');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No data available');
      } else {
        List<PrincipalData> a = snapshot.data!;

        List<SalesData> chartData = []; // Store the data for the chart

        switch (widget.index) {
          case 0:
            // Logic for today's data
            chartData = getChartData(a, isSameDay);
            break;
          case 1:
            // Logic for this week's data
            chartData = getChartData(a, isWithinWeek);
            break;
          case 2:
            // Logic for this month's data
            chartData = getChartData(a, isWithinMonth);
            break;
          case 3:
            // Logic for this year's data
            chartData = getChartData(a, isWithinYear);
            break;
          default:
        }

        return Container(
          width: double.infinity,
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <SplineSeries<SalesData, String>>[
              SplineSeries<SalesData, String>(
                color: Color.fromARGB(255, 47, 125, 121),
                width: 3,
                dataSource: chartData,
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
              ),
            ],
          ),
        );
      }
    },
  );
}

List<SalesData> getChartData(List<PrincipalData> data, bool Function(DateTime, DateTime) dateComparison) {
  return data.where((dataItem) {
    return dateComparison(dataItem.dataRegister, DateTime.now());
  }).map((dataItem) {
    return SalesData(
      dataItem.category, // Replace with your x-axis data
      double.parse(dataItem.amount),   // Replace with your y-axis data
    );
  }).toList();
}
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}