import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<PrincipalData> principalDataList = [];
  bool b = true;
  bool j = true;
  String selectedCategory = "";
  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<List<PrincipalData>> getDataFromFirebase({String? category}) async {
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
        if (category == null || category == principalData.category) {
          principalDataList.add(principalData);
          print("Dados Salvos");
        }
      });

      return principalDataList;
    } catch (e) {
      print('Error fetching data from Firebase: $e');
      return []; // Return an empty list in case of an error
    }
  }

  bool isWithinWeek(DateTime date1, DateTime date2) {
    return true;
  }

  bool isWithinMonth(DateTime date1, DateTime date2) {
    return true;
  }

  bool isWithinYear(DateTime date1, DateTime date2) {
    return true;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return true;
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
          selectedCategory = selectedCategory == "" ? a[0].category : selectedCategory;


          List<SalesData> chartData = []; // Store the data for the chart

          switch (widget.index) {
            case 0:
              // Logic for today's data
              chartData = getChartData(a, selectedCategory, isSameDay, 'day');
              break;
            case 1:
              // Logic for this week's data
              chartData =
                  getChartData(a, selectedCategory, isWithinWeek, 'week');
              break;
            case 2:
              // Logic for this month's data
              chartData =
                  getChartData(a, selectedCategory, isWithinMonth, 'month');
              break;
            case 3:
              // Logic for this year's data
              chartData =
                  getChartData(a, selectedCategory, isWithinYear, 'year');
              break;
            default:
          }

          return Column(
            children: [
              DropdownButton<String>(
                value: selectedCategory,
                hint: Text('Selecione uma categoria'),
                onChanged: (newValue) {
                  _onCategorySelected(newValue!);
                },
                items: a
                    .map((dataItem) =>
                        dataItem.category) // Extract only the categories
                    .toSet() // Convert to a set to ensure uniqueness
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              SizedBox(height: 10), // Add some spacing
              Container(
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
              ),
            ],
          );
        }
      },
    );
  }

  int getMonth(DateTime dateTime) => dateTime.month;
  int getYear(DateTime dateTime) => dateTime.year;
  int getDay(DateTime dateTime) => dateTime.day;
  int getWeek(DateTime dateTime) =>
      dateTime.weekday; // Note: This returns the day of the week (1-7)

  List<SalesData> getChartData(
      List<PrincipalData> data,
      String selectedCategory,
      bool Function(DateTime, DateTime) dateComparison,
      String interval) {
    int Function(DateTime) extractInterval;

    switch (interval) {
      case 'month':
        extractInterval = getMonth;
        break;
      case 'year':
        extractInterval = getYear;
        break;
      case 'day':
        extractInterval = getDay;
        break;
      case 'week':
        extractInterval = getWeek;
        break;
      default:
        throw ArgumentError('Invalid interval: $interval');
    }

    Map<String, double> intervalDataMap = {}; // Map to store interval data

    data.where((dataItem) {
      return dateComparison(dataItem.dataRegister, DateTime.now()) &&
          (selectedCategory.isEmpty || dataItem.category == selectedCategory);
    }).forEach((dataItem) {
      String intervalValue = extractInterval(dataItem.dataRegister).toString();
      double amount = double.parse(dataItem.amount);

      intervalDataMap.update(intervalValue, (value) => value + amount,
          ifAbsent: () => amount);
    });

    List<SalesData> salesDataList = intervalDataMap.entries.map((entry) {
      return SalesData(
        entry.key,
        entry.value,
      );
    }).toList();

    // Sort the salesDataList based on the interval values
    salesDataList.sort((a, b) => a.year.compareTo(b.year));

    return salesDataList;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
