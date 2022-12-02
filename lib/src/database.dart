import 'dart:io';

import 'package:ray_db/ray_db.dart';
import 'package:ray_db/src/collection.dart';
import 'package:ray_db/src/common.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

class Database {
  sq.Database db;

  Database(this.db) {}

  Collection collection(String collection) {
    return Collection(collection, db);
  }

  List<Collection> collections() {
    final stmt = db.prepare("PRAGMA table_list;");
    final ret = stmt.select();
    return ret
        .where((e) => !sqliteInnerTables.contains(e['name']))
        .map((e) => collection(e['name']))
        .toList();
  }

  bool hasCollection(String collection) {
    return Collection.hasCollection(db, collection);
  }
}

Future<Database> openDatabase(File dbFile) async {
  final dbSQLite = sq.sqlite3.open(dbFile.path);
  return Database(dbSQLite);
}
