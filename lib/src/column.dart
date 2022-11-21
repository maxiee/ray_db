import 'package:ray_db/src/constants.dart';

class Column {
  String name;
  DataType type;
  bool notNull;
  dynamic defaultValue;
  bool primaryKey;

  Column(this.name, this.type, this.notNull, this.primaryKey,
      {this.defaultValue});
}
