import 'package:hive/hive.dart';

import '../../Screens/category.dart';
part 'add_date.g.dart';

@HiveType(typeId: 1)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String explain;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String IN;
  @HiveField(4)
  DateTime datetime;

  Add_data(this.IN, this.amount, this.datetime, this.explain, this.name);


  // Novo construtor que aceita um objeto CategoryFB e cria um Add_data
  Add_data.fromCategory(CategoryFB category)
      : name = category.name ?? '',
        explain = '',
        amount = '',
        IN = category.type ?? '',
        datetime = DateTime.now();

}
