import 'package:hive/hive.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int totals = 0;

final box = Hive.box<Add_data>('data');

Future<double> totalLancamentos() async {
  double valorTotal = 0;

  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('lancamentos').get();

    List<double> amounts = snapshot.docs.map((doc) {
      double amount = double.parse(doc['amount']);
      return doc['type'] == 'Renda' ? amount : -amount;
    }).toList();

    valorTotal = amounts.reduce((value, element) => value + element);
  } catch (e) {
    return 0;
  }
  String numeroArredondado = valorTotal.toStringAsFixed(2); // Arredonda para duas casas decimais
  double valorTotalDouble = double.parse(numeroArredondado); // Converte de volta para double

  return valorTotalDouble;
}

Future<double> Renda() async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('lancamentos').get();

    double totalRenda = 0.0;

    snapshot.docs.forEach((doc) {
      if (doc['type'] == 'Renda') {
        totalRenda += double.parse(doc['amount']);
      }
    });
  String numeroArredondado = totalRenda.toStringAsFixed(2); // Arredonda para duas casas decimais
  double totalRendaDouble = double.parse(numeroArredondado); //
    return totalRendaDouble;
  } catch (e) {
    print('Error fetching data from Firebase: $e');
    return 0; // Retorna 0 em caso de erro
  }
}

Future<double> Expenses() async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('lancamentos').get();

    double totalExpenses = 0.0;

    snapshot.docs.forEach((doc) {
      if (doc['type'] != 'Renda') {
        totalExpenses += double.parse(doc['amount']);
      }
    });

  String numeroArredondado = totalExpenses.toStringAsFixed(2); // Arredonda para duas casas decimais
  double totalExpensesDouble = double.parse(numeroArredondado); //
    return totalExpensesDouble;
  } catch (e) {
    print('Error fetching data from Firebase: $e');
    return 0; // Retorna 0 em caso de erro
  }
}

List<Add_data> today() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.day == date.day) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> week() {
  List<Add_data> a = [];
  DateTime date = new DateTime.now();
  var history2 = box.values.toList();
  for (var i = 0; i < history2.length; i++) {
    if (date.day - 7 <= history2[i].datetime.day &&
        history2[i].datetime.day <= date.day) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> month() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.month == date.month) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> year() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.year == date.year) {
      a.add(history2[i]);
    }
  }
  return a;
}

int total_chart(List<Add_data> history2) {
  List a = [0, 0];

  for (var i = 0; i < history2.length; i++) {
    a.add(history2[i].IN == 'Renda'
        ? int.parse(history2[i].amount)
        : int.parse(history2[i].amount) * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

List time(List<Add_data> history2, bool hour) {
  List<Add_data> a = [];
  List total = [];
  int counter = 0;
  for (var c = 0; c < history2.length; c++) {
    for (var i = c; i < history2.length; i++) {
      if (hour) {
        if (history2[i].datetime.hour == history2[c].datetime.hour) {
          a.add(history2[i]);
          counter = i;
        }
      } else {
        if (history2[i].datetime.day == history2[c].datetime.day) {
          a.add(history2[i]);
          counter = i;
        }
      }
    }
    total.add(total_chart(a));
    a.clear();
    c = counter;
  }
  print(total);
  return total;
}
