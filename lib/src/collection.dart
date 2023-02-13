import 'package:ray_db/src/column.dart';
import 'package:ray_db/src/constants.dart';
import 'package:ray_db/src/selector_builder.dart';
import 'package:ray_db/src/util/data_utils.dart';
import 'package:sqlite3/sqlite3.dart' as sq;
import 'package:uuid/uuid.dart';

class Collection {
  sq.Database db;
  String collection;
  Map<String, Column> columns = {};

  Collection(this.collection, this.db) {
    if (collection.contains(';') || collection.contains(' ')) {
      throw const FormatException();
    }
    db.execute(
        'CREATE TABLE IF NOT EXISTS $collection (id INTEGER PRIMARY KEY)');
    parseColumns();
  }

  SelectorBuilder where() {
    return SelectorBuilder(this);
  }

  Map<String, dynamic> storeMap(Map<String, dynamic> data) {
    List<String> sqlColumns = [];
    List<dynamic> sqlValues = [];
    final ret = Map<String, dynamic>.from(data);

    bool isExisted = data.containsKey('uuid') && data['uuid'] != null;

    if (!isExisted) {
      String uuid = const Uuid().v4();
      sqlColumns.add('uuid');
      sqlValues.add(uuid);
      ret['uuid'] = uuid;

      if (!columns.containsKey('uuid')) {
        createColumn('uuid', InnerDataType.TEXT);
      }
    }

    for (final entry in data.entries) {
      String key = entry.key;
      dynamic value = entry.value;
      // don't create column for field with null value
      // because we don't the exactly type
      if (value == null) continue;
      InnerDataType valueType = DataUtils.parseObjType(value);

      if (!columns.containsKey(key)) {
        createColumn(key, valueType);
      }

      sqlColumns.add(key);
      sqlValues.add(value);
    }

    if (isExisted) {
      db.execute(
          "UPDATE $collection SET (${sqlColumns.join(',')}) = (${sqlValues.map((e) => "?").join(',')}) WHERE uuid = ?;",
          [...sqlValues, sqlValues[sqlColumns.indexOf("uuid")]]);
    } else {
      db.execute(
          "INSERT INTO $collection (${sqlColumns.join(',')}) VALUES(${sqlValues.map((e) => "?").join(',')});",
          sqlValues);
      ret['id'] = db.lastInsertRowId;
    }
    return ret;
  }

  void parseColumns() {
    final stmt = db.prepare("PRAGMA table_info($collection);");
    final ret = stmt.select();
    // print('parseColumns ret = $ret');
    for (Map column in ret) {
      String name = column['name'];
      Column c = Column(name, DataUtils.parseType(column['type']),
          column['notnull'] == 1, column['pk'] == 1,
          defaultValue: column['dflt_value']);
      columns[name] = c;
    }
  }

  void createColumn(String name, InnerDataType type) {
    db.execute("ALTER TABLE $collection ADD $name ${type.name}");
    columns[name] = Column(name, type, false, false);
  }

  static hasCollection(sq.Database db, String collection) {
    final ret = db.select(
        'SELECT name FROM sqlite_master WHERE type=\'table\' AND name=?',
        [collection]);
    // print(ret);
    return ret.isNotEmpty;
  }
}
